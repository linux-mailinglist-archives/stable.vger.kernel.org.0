Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C5230B837
	for <lists+stable@lfdr.de>; Tue,  2 Feb 2021 08:03:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231600AbhBBHCg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 2 Feb 2021 02:02:36 -0500
Received: from mail.kernel.org ([198.145.29.99]:51038 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232210AbhBBHCc (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 2 Feb 2021 02:02:32 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id A1D6D64EC5;
        Tue,  2 Feb 2021 07:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1612249220;
        bh=OpVE2u9pmy8YxbusnuRIY8cPakS2ERFrJru8E9V/uyA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=KRjFSS1vDJLCuccAhwtM1iE3k8oqcPuNbZbrEhlJNuuPNbfAz7J3vRqvx7PIEY+Fx
         G0BTsQz6GGVCDEjSpvXxhGwisFg6KkEcbFNpk2LIqcbiCzvDaiW4WrNPCCWETl7uSS
         RoQVAIw2wbV0Ke5QsOrEhPkiSL42op+OKHcOeyNQ=
Date:   Tue, 2 Feb 2021 08:00:17 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Chunfeng Yun <chunfeng.yun@mediatek.com>
Cc:     ikjn@chromium.org, stable@vger.kernel.org
Subject: Re: patch "usb: xhci-mtk: skip dropping bandwidth of unchecked
 endpoints" added to usb-linus
Message-ID: <YBj4gcIuj1oTo4Xh@kroah.com>
References: <1612185061176212@kroah.com>
 <1612247694.25113.15.camel@mhfsdcap03>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612247694.25113.15.camel@mhfsdcap03>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 02, 2021 at 02:34:54PM +0800, Chunfeng Yun wrote:
> Hi Greg,
> 
>    I sent out v2, add 'break' when find the ep in
> xhci_mtk_drop_ep_quirk(), but no effect with the function.
> Please pick up v2 if possible, sorry for inconvenience

I can not do that, as it is already in my public tree.

I can either revert the existing one, and take this, or just accept a
follow-on patch.  I prefer a follow-on one, please send that.

thanks,

greg k-h
