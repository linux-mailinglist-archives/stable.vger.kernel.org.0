Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 308EA498BE3
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 20:17:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348483AbiAXTRX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 14:17:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348414AbiAXTPW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 24 Jan 2022 14:15:22 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D87DC03400E
        for <stable@vger.kernel.org>; Mon, 24 Jan 2022 11:06:21 -0800 (PST)
Received: from mail.denx.de (unknown [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: festevam@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id 9997680FB8;
        Mon, 24 Jan 2022 20:06:18 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1643051178;
        bh=eJqU5HoNskwrB76YiZTeWI1K0mmLX35TDfMCq60L95k=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=poun2HvpiXzfjUKSZZrxEd4arwfWTg//NIJYR1kyQPd4+/ixelnE7oFiQBKX4/S8e
         WgZK0PMN5bAmQZ6wbfenubiEXaml0Fpx0psf8J4Aje/7lxXw13yURdpH9NstDQ/B0o
         NyWcFAsReIDGfH60+Bs8pT609Ao+FQiK1xqNHcSpvg+TYZ9laWQgjqPaf5NJkplCxO
         R0ftz4Kl9jPTCJ2pWiWq/FEsyexUQLiflJWlrCxOX3UxPAtHrxC0CAE7keQwcGAKUM
         4If7fIsRI4R9g8+Y8iAZWO4hjWxUkZhoflVllETFmf6YOQAFRjF+42unVj6ZxLbTSt
         rRTa+3Y4ZxekA==
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 24 Jan 2022 16:06:18 -0300
From:   Fabio Estevam <festevam@denx.de>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, sashal@kernel.org,
        Kalle Valo <quic_kvalo@quicinc.com>
Subject: Re: [PATCH v3 stable-5.10] ath10k: Fix the MTU size on QCA9377 SDIO
In-Reply-To: <Ye7vPkJRPILUeCaH@kroah.com>
References: <20220124171042.1454727-1-festevam@denx.de>
 <Ye7vPkJRPILUeCaH@kroah.com>
Message-ID: <924818fcf64c2caceadf1347d04836b9@denx.de>
X-Sender: festevam@denx.de
User-Agent: Roundcube Webmail/1.3.6
X-Virus-Scanned: clamav-milter 0.103.5 at phobos.denx.de
X-Virus-Status: Clean
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 24/01/2022 15:26, Greg KH wrote:

> Ok, trying this again...

Thanks and sorry for the trouble.

Cheers,

Fabio Estevam
-- 
DENX Software Engineering GmbH,      Managing Director: Wolfgang Denk
HRB 165235 Munich, Office: Kirchenstr.5, D-82194 Groebenzell, Germany
Phone: (+49)-8142-66989-60 Fax: (+49)-8142-66989-80 Email: 
festevam@denx.de
