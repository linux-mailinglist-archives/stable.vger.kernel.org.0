Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD2863E41DD
	for <lists+stable@lfdr.de>; Mon,  9 Aug 2021 10:53:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234078AbhHIIx2 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Aug 2021 04:53:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:52376 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234003AbhHIIx1 (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 9 Aug 2021 04:53:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4861A60FC2;
        Mon,  9 Aug 2021 08:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1628499187;
        bh=NKQYnHMpwrmlOF/0hhiWzGMytsmZUxB83fbyaGI7+oA=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Hve34o87KK3wh33FKKxM6W9gkrkiTc5QQO4mpA8HocWxn3n9rPpJ0yf5bSI2I4/hI
         I1g119GjmGQlnWu2ykSm0+h/DigzgGk5TWsX8gL4bK90pb3FeE6FhsdJE8gW9Ihv1d
         8KC7Mpmn1G7Bv8NO9rxNm20jKwt1IxTOaMmojX7U=
Date:   Mon, 9 Aug 2021 10:53:05 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Sam Protsenko <semen.protsenko@linaro.org>
Cc:     stable@vger.kernel.org, Wesley Cheng <wcheng@codeaurora.org>
Subject: Re: Add "usb: dwc3: Stop active transfers before halting the
 controller" to 5.4-stable
Message-ID: <YRDs8YYl1uEycsQl@kroah.com>
References: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPLW+4nyWAp99CTVy+wJ0rnbs9JpDvNaQaVityJi=sVPTkyDSA@mail.gmail.com>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 06, 2021 at 04:25:17PM +0300, Sam Protsenko wrote:
> Hi Greg,
> 
> Suggest including next patch (available in linux-mainline) to
> 5.4-stable branch: commit ae7e86108b12 ("usb: dwc3: Stop active
> transfers before halting the controller"). It's also already present
> in 5.10 stable. Some fixes exist in 5.10-stable for that patch too.

Can you provide a list of the fixes that also need to be backported?  I
do not want to take one patch and not all of the relevant ones.

thanks,

greg k-h
