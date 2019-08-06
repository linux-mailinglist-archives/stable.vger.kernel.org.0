Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 77B28834DA
	for <lists+stable@lfdr.de>; Tue,  6 Aug 2019 17:15:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728156AbfHFPPP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 6 Aug 2019 11:15:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:58302 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726877AbfHFPPP (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 6 Aug 2019 11:15:15 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 475DA20717;
        Tue,  6 Aug 2019 15:15:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1565104514;
        bh=I9Bf8CCcuS/F1rOk/abaMRdQEiZ8r0dTOJjcA1V/iCw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=FaNAJ17+xabayWk7QGl5C8KvziMTp2EPw/MpUqPdVBDEMO5+uCDvlKjsKPf1CIIdi
         bVwMKh+nBMjzJwRXuThkWeAHj8pRisrrOtWchfVMRJtKRAaQiZMzvx2zVWeJANVUH2
         /vzhggC7y7HSb+IGdsr+MQJP+CJSugLbOcKWWiCg=
Date:   Tue, 6 Aug 2019 17:15:12 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Adam Ford <aford173@gmail.com>
Cc:     stable@vger.kernel.org
Subject: Re: ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV
Message-ID: <20190806151512.GA6051@kroah.com>
References: <CAHCN7xJUd0ZmC86_NsS+8j+o5M0iQipGJuh00nV0=V=qt5Jtaw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHCN7xJUd0ZmC86_NsS+8j+o5M0iQipGJuh00nV0=V=qt5Jtaw@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 06, 2019 at 10:06:24AM -0500, Adam Ford wrote:
> Please apply 5fe3c0fa0d54877c65e7c9b4442aeeb25cdf469a
>  ("ARM: dts: Add pinmuxing for i2c2 and i2c3 for LogicPD SOM-LV") to
> 4.9.y branch.
> 
> Ideally, it would be applied to 4.4, but It doesn't apply cleanly to
> 4.4.  I can do a separate patch to do that, but I am not sure of the
> proper procedure.

Just send a backported patch to the list, saying what the git commit id
was in Linus's tree.  THere are loads of examples in the archives for
how to do this properly.

thanks,

greg k-h
