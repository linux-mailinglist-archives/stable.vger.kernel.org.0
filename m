Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 106A5181FB3
	for <lists+stable@lfdr.de>; Wed, 11 Mar 2020 18:41:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730235AbgCKRlh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 11 Mar 2020 13:41:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:60966 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgCKRlg (ORCPT <rfc822;stable@vger.kernel.org>);
        Wed, 11 Mar 2020 13:41:36 -0400
Received: from gmail.com (unknown [104.132.1.77])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id BF31F2073E;
        Wed, 11 Mar 2020 17:41:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583948497;
        bh=bgSmYq0cHTA9/4QmAQKlWfxb9DYO4QtAo2xGhsXLHps=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yYhgVgcpvDOsH3WNqqv4VJaIHxs5wN4tGA9bBiWMCq51SV1jtYQeY/3Hg+G2tNEhf
         OEMzIGYpDTyPBJJFUwtTeCGd6V9ckxD2m3X5NJ0dT4GXQK46sRT3I+MK1GJTAZaw43
         6jccbBjs49GmqycJtbbyE3DYqlA03nzqLIuV2Grk=
Date:   Wed, 11 Mar 2020 10:41:34 -0700
From:   Eric Biggers <ebiggers@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        stable@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jeff Vander Stoep <jeffv@google.com>,
        Jessica Yu <jeyu@kernel.org>,
        Luis Chamberlain <mcgrof@kernel.org>
Subject: Re: [PATCH] kmod: make request_module() return an error when
 autoloading is disabled
Message-ID: <20200311174134.GB20006@gmail.com>
References: <20200310223731.126894-1-ebiggers@kernel.org>
 <202003111026.2BBE41C@keescook>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <202003111026.2BBE41C@keescook>
User-Agent: Mutt/1.12.2 (2019-09-21)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Wed, Mar 11, 2020 at 10:28:07AM -0700, Kees Cook wrote:
> On Tue, Mar 10, 2020 at 03:37:31PM -0700, Eric Biggers wrote:
> > From: Eric Biggers <ebiggers@google.com>
> > 
> > It's long been possible to disable kernel module autoloading completely
> > by setting /proc/sys/kernel/modprobe to the empty string.  This can be
> 
> Hunh. I've never seen that before. :) I've always used;
> 
> echo 1 > /proc/sys/kernel/modules_disabled
> 
> Regardless,
> 
> Reviewed-by: Kees Cook <keescook@chromium.org>
> 

modules_disabled is different because it disables *all* module loading, not just
autoloading.

- Eric
