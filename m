Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7E937346E9
	for <lists+stable@lfdr.de>; Tue,  4 Jun 2019 14:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727394AbfFDMef (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 4 Jun 2019 08:34:35 -0400
Received: from mail.kernel.org ([198.145.29.99]:40102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727358AbfFDMef (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 4 Jun 2019 08:34:35 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7D2312231F;
        Tue,  4 Jun 2019 12:34:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1559651675;
        bh=JHK28hUSgK/AGhD/1DJUomtda3ejLbkG9w4ZFLAu3+s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xn2OKFWlXxVcQzzxdC2xt93oiPzey7H2jDy8F4BtnB3uJO9uN+PaLnQ46gMco2+Ys
         OwR3zD069rV+qzmrVBDIWMuvBr6VosJ6hqTUI9hz9haQcSysOWUG6aGvRbC8/eZH+U
         XXgbVW0JRzS50gLr9Zoxs96qRO0t/qlXQUofKHcU=
Date:   Tue, 4 Jun 2019 14:34:32 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Zubin Mithra <zsm@chromium.org>
Cc:     stable@vger.kernel.org, groeck@chromium.org,
        blackgod016574@gmail.com, ard.biesheuvel@linaro.org,
        dvhart@infradead.org, andy@infradead.org, tglx@linutronix.de,
        mingo@redhat.com, bp@alien8.de
Subject: Re: 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap
 1:1 mapping code")
Message-ID: <20190604123432.GA19996@kroah.com>
References: <20190603223851.GA162395@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603223851.GA162395@google.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Jun 03, 2019 at 03:38:52PM -0700, Zubin Mithra wrote:
> Hello,
> 
> CVE-2019-12380 was fixed in the upstream linux kernel with the commit :-
> * 4e78921ba4dd ("efi/x86/Add missing error handling to old_memmap 1:1 mapping code")
> 
> Could the patch be applied in order to v4.19.y?

Now queued up, thanks.

greg k-h
