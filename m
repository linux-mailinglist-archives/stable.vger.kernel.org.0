Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 04629697236
	for <lists+stable@lfdr.de>; Wed, 15 Feb 2023 00:58:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232151AbjBNX52 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Feb 2023 18:57:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232814AbjBNX5X (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Feb 2023 18:57:23 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B636522DE2
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 15:57:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1676419042; x=1707955042;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=kzhGYJXOf306NmlEn5opNfn1hoJ34kE37xo2DHXERFc=;
  b=COysZuK7gAnbsgjs9MRblYUvobdU62/We1IiPnmxIwUMdgjJwCz7ll2a
   5+pxYI+inagX1HixEmeZTun8MZUwX8B9Q0chGRngNMi3JhDNgF8sqGB63
   qnk8ZPNok826cuz+bSnveB4Ap75PfepR4p3pXtPldGA513200K90RFl40
   1oOuF1s1okAjOyCxHXbn1XpUj5+mOmG3SDzdnRJLLcH34KFzCrT693REU
   8eqUDpciT3dSiitvAy1vf/8KZ6bZEfslqoROpPKbhz5bF9z5d5T/klYR7
   YRgBTt15SLN41oiJktXWq+pJJXC5ZaQqd+yHML5Tquh/Tgo00vWX9Pk8O
   g==;
X-IronPort-AV: E=Sophos;i="5.97,298,1669046400"; 
   d="scan'208";a="223111130"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 15 Feb 2023 07:57:21 +0800
IronPort-SDR: vMuqYzctTtMI21V7vGHUEdb9Fe+d0NpjO4mJYhIsN8g8aaY2LxoaVBedUwmi4+cbVLxX7lcFe4
 SHaTbJVp5hBwFcPs5rLbmJyv2G/NCLI2btsMkfazKilcFYm5t47ZWN7rsRRYP2/LYJnsfP3r2e
 Dz+PmVi6vJv8RP9rrXFAYXnE1KohSNevFseEOYqDiH6NZktHZAvV+xRxfxkp1KipjQNQzK+UrI
 dIV7OrlXIzcmYETd/AUybbZS/GcrJurc/nNUSAr79TH7R6FLgmeZOL740TLqjsmmPkO91EXVqm
 gL0=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 15:08:44 -0800
IronPort-SDR: YbUA2JbXGVCq+h654YKm04uB3BMRfJRRi19I1iLYDU3+6/xI4tqw8MJ8iFA7JW/meOltNbkp9u
 SSyuZr2dCYOAWps8AYSIh+820RAn3Eibtj7315jbVkIJrQDVPrl/Poj93qyGO+8B23Tdo3frB4
 MLPpm+dbBkTOxdvn51Pih1+uq1UpX5t3ihlgKbzAL6ATOO3a05eEzZZd7QqSagbMpx2FH5mgXi
 KxlK1OZfgKmFtJS4710maiWKsb3jKLiCXOl3kSjmg1t+/bLEHVHmayujN1yIB6VLy/XjjhR/S9
 mW0=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 14 Feb 2023 15:57:22 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PGdRj3wBkz1Rwt8
        for <stable@vger.kernel.org>; Tue, 14 Feb 2023 15:57:21 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1676419041; x=1679011042; bh=kzhGYJXOf306NmlEn5opNfn1hoJ34kE37xo
        2DHXERFc=; b=Y/Dgtdyfk1DZr1y9FaRQ9iQ3bW9o3h/ZiqeOJ+OYZh4GnRI3qrZ
        coD77hN4dnBmN8xCj90UpBUOi1Y7y+cKFrgpugDphQt++Se6R3pZjEXgcbeM65eI
        fLPpvWeahTWCl4HWYmzVtvcW+tUYCYjq+S/nGLQq2Hdfp5N5x/DMpqB2CuOr0irn
        QM4f2b9HBpWdhrW7wX27N+astwuzJgBj4wg0tOB9zXJC27UlCP/lzfxHMzoQnvJk
        oFre7iuXHrc0eilZdJMQvsvkbXoYrS5ypZEsi7P/EyYADshcbmmrS1lavNC4ntlQ
        VabshpRcZ9NTA/IVY+JKEbV56TGKBU5gRjQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id hwom9O-gdmR8 for <stable@vger.kernel.org>;
        Tue, 14 Feb 2023 15:57:21 -0800 (PST)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PGdRd292Tz1RvLy;
        Tue, 14 Feb 2023 15:57:17 -0800 (PST)
Message-ID: <b6a27883-5d79-1125-70a7-ba987b397bcc@opensource.wdc.com>
Date:   Wed, 15 Feb 2023 08:57:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH v2 2/9] PCI: rockchip: Write PCI Device ID to correct
 register
Content-Language: en-US
To:     Rick Wertenbroek <rick.wertenbroek@gmail.com>,
        alberto.dassatti@heig-vd.ch
Cc:     xxm@rock-chips.com, rick.wertenbroek@heig-vd.ch,
        stable@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Heiko Stuebner <heiko@sntech.de>,
        Shawn Lin <shawn.lin@rock-chips.com>,
        Lorenzo Pieralisi <lpieralisi@kernel.org>,
        =?UTF-8?Q?Krzysztof_Wilczy=c5=84ski?= <kw@linux.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Jani Nikula <jani.nikula@intel.com>,
        Mikko Kovanen <mikko.kovanen@aavamobile.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-rockchip@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org
References: <20230214140858.1133292-1-rick.wertenbroek@gmail.com>
 <20230214140858.1133292-3-rick.wertenbroek@gmail.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20230214140858.1133292-3-rick.wertenbroek@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 2/14/23 23:08, Rick Wertenbroek wrote:
> Write PCI Device ID (DID) to the correct register. The Device ID was not
> updated through the correct register. Device ID was written to a read-only
> register and therefore did not work. The Device ID is now set through the
> correct register. This is documented in the RK3399 TRM section 17.6.6.1.1
> 
> Fixes: cf590b078391 ("PCI: rockchip: Add EP driver for Rockchip PCIe controller")
> Cc: stable@vger.kernel.org
> Signed-off-by: Rick Wertenbroek <rick.wertenbroek@gmail.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

