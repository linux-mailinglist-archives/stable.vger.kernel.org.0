Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A8678AF3F
	for <lists+stable@lfdr.de>; Tue, 13 Aug 2019 08:09:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727324AbfHMGJg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 13 Aug 2019 02:09:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:45172 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725815AbfHMGJg (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 13 Aug 2019 02:09:36 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1204C206C2;
        Tue, 13 Aug 2019 06:09:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565676575;
        bh=LCQFHO3hgyDcsNE4OVgszUQjvgfDNl82Jh1CeyUHBMQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fKwl44TzDZp7q0lNZI+UhhKYk1cmhvfj4wffPaQgP1pNuvOfq8sPB4zC6W2VP3v76
         uFqUvdCb2wRKFW7S7BFyhHz1HZn2oyG1ZUFXVl51HCe+hZK+ZHsMgTdQ2zIQeF/7s0
         tV0XQYimYmLaZlgQurIJ2onPg4aRz2flY/XdhUOs=
Date:   Tue, 13 Aug 2019 08:09:33 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Nick Desaulniers <ndesaulniers@google.com>
Cc:     stable@vger.kernel.org, pcc@google.com,
        Nathan Chancellor <natechancellor@gmail.com>,
        Alan Modra <amodra@gmail.com>,
        Jordan Rupprect <rupprecht@google.com>,
        Kees Cook <keescook@chromium.org>
Subject: Re: [4.14 PATCH] lkdtm: support llvm-objcopy
Message-ID: <20190813060933.GG6670@kroah.com>
References: <20190812211750.61025-1-ndesaulniers@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190812211750.61025-1-ndesaulniers@google.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 12, 2019 at 02:17:50PM -0700, Nick Desaulniers wrote:
> This backport is for 4.14.  It should allow us to use llvm-objcopy for
> RELR relocations on arm64 in Android.

I don't object to this, but the odds that you are actually using the
lkdtm driver on Android systems is pretty slim :)

thanks,

greg k-h
