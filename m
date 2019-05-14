Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E64891C040
	for <lists+stable@lfdr.de>; Tue, 14 May 2019 03:06:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726327AbfENBGf (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 May 2019 21:06:35 -0400
Received: from mail-oi1-f194.google.com ([209.85.167.194]:41814 "EHLO
        mail-oi1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726233AbfENBGe (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 May 2019 21:06:34 -0400
Received: by mail-oi1-f194.google.com with SMTP id y10so10835198oia.8
        for <stable@vger.kernel.org>; Mon, 13 May 2019 18:06:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:openpgp:autocrypt:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=az2VtHYhE9+JpA8cUOPC5jdS+VizjCy/so0vBfIYfFA=;
        b=IvtD+fsmF46s5B91oqgwwGuo1YzL/SYuipbHcjZ/9GI/hBZ8PyMKsnYQhvnQAlzG44
         ImgWDagypszG7aDH65xqYDbZixPAh+zlm4Cmd/tvJ77H2+JH80WUQ76YC9y8FcIFJ4mZ
         csWOr9aBBOsK8y46yeH5K6M/b3d6VKo26FWAEQAvaiL9d2gDPkFLoHXqRZEP4C0ykIj3
         voX7YrnVLjsFN4N54c5EO0JeKNE57wyyQ/8QYcMvMsrL8COFTOOq/NFypfLkqYkarxT/
         DPCS2vVEieQu6By1NWrA4xXKrynEnhJMvXdMNwroBHstBV/ok6FfvsjZmhJtI8/zERBV
         CvOw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=az2VtHYhE9+JpA8cUOPC5jdS+VizjCy/so0vBfIYfFA=;
        b=gb7YAAs5ia4sYZv78OujbDb29sAjrhjecfX5GJ2GUD5NaXHBbU6kR6SV2YIuwZ72lo
         ueS0vv11YS9cxq8qTllCwxP5NU6+48Wth+lVX7hIQAvDptiarTSWBIlGcgyA6EQn73Hf
         7grY6111ZsMFXe33qD21Ey/EKxFnfAzsARp/lTEFFidxx3Hu9kv9CovXN1UAF0w/zOXS
         CiHg3mDikdJK5MSckcOi5pAx9FwkUDCmtyCk8YINT5kX70ZYN82uOWlwDZP8tai45IPm
         BgxnrquFuOKi8K71STPcfR4NNiXEdDdYDX2z2F+5WDtNCFvNdiqTvHPz4u/O4q+PNiZo
         LIfw==
X-Gm-Message-State: APjAAAX8jZT7gQZR4dyB8PQejIbGgseYnr7nF+wlwgzO1nfe1cI4lJOw
        vHgkOowXkSVnHfM5ZIVJT8IBIkOr
X-Google-Smtp-Source: APXvYqz/BCor5GpnG2rGahbKDUwYB533VnqugF3TX+xwj08ARzAw1qurIiLczHXIWUn2ILh+C2UAAg==
X-Received: by 2002:aca:de45:: with SMTP id v66mr1229220oig.84.1557795993621;
        Mon, 13 May 2019 18:06:33 -0700 (PDT)
Received: from [192.168.1.2] (ip68-101-123-102.oc.oc.cox.net. [68.101.123.102])
        by smtp.googlemail.com with ESMTPSA id g84sm5899811oia.31.2019.05.13.18.06.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 13 May 2019 18:06:32 -0700 (PDT)
Subject: Re: [PATCH v3] ARM: dts: imx: Fix the AR803X phy-mode
To:     Sasha Levin <sashal@kernel.org>,
        "George G. Davis" <george_davis@mentor.com>
Cc:     andrew@lunn.ch, baruch@tkos.co.il,
        Fabio Estevam <festevam@gmail.com>, ken.lin@advantech.com,
        stable@vger.kernel.org, smoch@web.de,
        stwiss.opensource@diasemi.com, linux-imx@nxp.com,
        kernel@pengutronix.de, aford173@gmail.com,
        Marc Kleine-Budde <mkl@pengutronix.de>, shawnguo@kernel.org,
        linux-arm-kernel@lists.infradead.org
References: <20190403221241.4753-1-festevam@gmail.com>
 <20190513171826.GA18591@mam-gdavis-lt> <20190514004539.GG11972@sasha-vm>
From:   Florian Fainelli <f.fainelli@gmail.com>
Openpgp: preference=signencrypt
Autocrypt: addr=f.fainelli@gmail.com; prefer-encrypt=mutual; keydata=
 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
 a9BQwACgnzGuH1BVeT2J0Ra+ZYgkx7DaPR0=
Message-ID: <e7a3c9f6-8a29-3048-a0b9-8e7955f25b54@gmail.com>
Date:   Mon, 13 May 2019 18:06:22 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <20190514004539.GG11972@sasha-vm>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Le 5/13/19 à 5:45 PM, Sasha Levin a écrit :
> On Mon, May 13, 2019 at 01:18:27PM -0400, George G. Davis wrote:
>> Hello,
>>
>> On Wed, Apr 03, 2019 at 07:12:41PM -0300, Fabio Estevam wrote:
>>> Commit 6d4cd041f0af ("net: phy: at803x: disable delay only for RGMII
>>> mode")
>>> exposed an issue on imx DTS files using AR8031/AR8035 PHYs.
>>>
>>> The end result is that the boards can no longer obtain an IP address
>>> via UDHCP, for example.
>>>
>>> Quoting Andrew Lunn:
>>>
>>> "The problem here is, all the DTs were broken since day 0. However,
>>> because the PHY driver was also broken, nobody noticed and it
>>> worked. Now that the PHY driver has been fixed, all the bugs in the
>>> DTs now become an issue"
>>>
>>> To fix this problem, the phy-mode property needs to be "rgmii-id", 
>>> which
>>> has the following meaning as per
>>> Documentation/devicetree/bindings/net/ethernet.txt:
>>>
>>> "RGMII with internal RX and TX delays provided by the PHY, the MAC
>>> should
>>> not add the RX or TX delays in this case)"
>>>
>>> Tested on imx6-sabresd, imx6sx-sdb and imx7d-pico boards with
>>> successfully restored networking.
>>>
>>> Based on the initial submission from Steve Twiss for the
>>> imx6qdl-sabresd.
>>>
>>> Signed-off-by: Fabio Estevam <festevam@gmail.com>
>>> Tested-by: Baruch Siach <baruch@tkos.co.il>
>>> Tested-by: Soeren Moch <smoch@web.de>
>>> Tested-by: Steve Twiss <stwiss.opensource@diasemi.com>
>>> Tested-by: Adam Thomson <Adam.Thomson@diasemi.com>
>>> Signed-off-by: Steve Twiss <stwiss.opensource@diasemi.com>
>>> Tested-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
>>> ---
>>> Changes since v2:
>>> - Also fixed imx6q-ba16
>>> - Removed stable tag as it does not apply cleanly on older
>>> stable trees. I can manually generate versions for stable
>>> trees after this one hits mainline.
>>
>> Please add this commit to the v5.1.x stable queue to resolve NFS root
>> breakage
>> in v5.1. I can confirm that it applies cleanly to v5.1.1 and resolves
>> NFS root
>> breakage that occurs on i.MX6 boards in v5.1.x, tested on
>> imx6q-sabreauto.dts
>> and imx6q-sabresd.dts. Although the fix should be backported to
>> pre-v5.1.x
>> stable series as well, it does not cause problems for pre-v5.1 but
>> results in
>> NFS root breakage for v5.1.x.
> 
> What's the commit id in Linus's tree? I don't see it.

That would be 6d4cd041f0af5b4c8fc742b4a68eac22e420e28c ("net: phy:
at803x: disable delay only for RGMII mode").

I would use that as a Fixes: tag BTW.
-- 
Florian
