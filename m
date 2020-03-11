Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BE58181049
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 06:55:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726472AbgCKFzo convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Wed, 11 Mar 2020 01:55:44 -0400
Received: from relay10.mail.gandi.net ([217.70.178.230]:46423 "EHLO
        relay10.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKFzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 11 Mar 2020 01:55:44 -0400
Received: from [26.83.49.98] (unknown [172.58.107.189])
        (Authenticated sender: josh@joshtriplett.org)
        by relay10.mail.gandi.net (Postfix) with ESMTPSA id 4BB0A240005;
        Wed, 11 Mar 2020 05:55:37 +0000 (UTC)
Date:   Wed, 11 Mar 2020 06:55:30 +0100
In-Reply-To: <20200311043221.GK11244@42.do-not-panic.com>
References: <20200310223731.126894-1-ebiggers@kernel.org> <20200311043221.GK11244@42.do-not-panic.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 8BIT
Subject: Re: [PATCH] kmod: make request_module() return an error when autoloading is disabled
To:     Luis Chamberlain <mcgrof@kernel.org>,
        Eric Biggers <ebiggers@kernel.org>, NeilBrown <neilb@suse.com>
CC:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Kees Cook <keescook@chromium.org>, benh@debian.org
From:   Josh Triplett <josh@joshtriplett.org>
Message-ID: <0256C870-590C-426A-B4DF-4C272E46B75F@joshtriplett.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On March 11, 2020 5:32:21 AM GMT+01:00, Luis Chamberlain <mcgrof@kernel.org> wrote:
>On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote: 
>> However, request_module() should also
>> correctly return an error when it fails.  So let's make it return
>> -ENOENT, which matches the error when the modprobe binary doesn't
>exist.
>
>This is a user experience change though, and I wouldn't have on my
>radar
>who would use this, and expects the old behaviour. Josh, would you by
>chance?

I don't think this affects userspace. But I'd suggest Ben Hutchings (CCed).
