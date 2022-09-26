Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 994A55EB5B5
	for <lists+stable@lfdr.de>; Tue, 27 Sep 2022 01:24:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229529AbiIZXYq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Sep 2022 19:24:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231423AbiIZXYR (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Sep 2022 19:24:17 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B26AE119192
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 16:22:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664234556; x=1695770556;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=IRHeXZ/NpwwH/OredQ5SvJnDZr+RKdF2QXW8lGQc/q8=;
  b=YXYzir5EF0PESMhqN4WtVGwHD5yWFLfX9K+TUZJbKxLOzErDxxA+IAky
   HCCh/wK/HSmo5WqaTBdXDRGx8hmazLghQSENor4o9EaYspcaq/5DwjZym
   S0OwgtCQA69O9Wa4J7Uuv55CqnHDZhjURS4kCi57RIJb85QXOvfMzQvz4
   NOe30Yn6I14ycf1jIEgS24RsXvwuBEUDIIZSwiSq3g0oqDRqtJUajTThB
   XNHwfToEoSQM85C7kUQmH72fYD9MrUri+8YSaew2cEUheLmqFxF9wIafv
   3Fro6FWZB+v4+h12xuMah+kOBTyLbFPiz553N7Z1YuK8cP0so7AgqTG5q
   g==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="212747238"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 07:22:33 +0800
IronPort-SDR: HkN0BRCfyMxmTonhUpWyY010Wwo+L9b7uVC/IFT4ipRmozRg7oT3SU2PTO3N7sMbbrzZWh+bP3
 OKEAz0yY5rCnufeodpgQlcLStWeNaHKrOcbSUziWUqakXjFGjvWT/QJtLVWk7ojtBWovA9AXE8
 EwwRy4MQoLRn0LpvLHH1vPYWOHsUKY55OEJu3mS4QScRdFWtnjLyHgkm8JPqmPp/2DxudFvASf
 ptb2+f2oq13hojQA/6iidrDA7JIwQuwSuFlP3aF01yeoGe9ocgtpdwUfVNMkvfKZeR+ssA++oU
 GpdmnbjSYELfTkIdK4NqV575
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 15:42:30 -0700
IronPort-SDR: 72M6o2yDH6h6uvbffNbUQF/a7ekkc9rHik1ppSNSYDXtqKOf2Db/XuyKrC4Lk6bhumIMTIFnO/
 gnUqZn0IfzGJ4+il6VC2x51d6GsViNybQQ9FQ7ggGgKwJXiNGPCA5XvCF76g3DaCAenqyi6xwX
 5nQWn1LWukFgwGniry8H3q9HsfbazY+sPhg5cFNrcr/kNVgIEhwtbU+Yc/O6vffYl48WBuoXGj
 yuKDBAhg/FRNfRYum/nY3YAVk0ZTQ1ZPC06MSOWM0EJrSM+5wXQBEBGMxXmnKIlTXInRu3NUBf
 6KA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 16:22:33 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MbzLc5Sv4z1Rwt8
        for <stable@vger.kernel.org>; Mon, 26 Sep 2022 16:22:32 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664234552; x=1666826553; bh=IRHeXZ/NpwwH/OredQ5SvJnDZr+RKdF2QXW
        8lGQc/q8=; b=TzDu22YWhtfg64q5OgmXoDyiZIprAxcGTbqRLD1MjXCAQEXJeOT
        1ZAOmICx47uwJy5dmR2eJceLhEA/VvT9RWZ5M5CMk+cN4NLV4j/qNj3E7JOOui/f
        lmXDxoPve5CHOj8SvfKHLBf0zJ60P6bVHctcHQ9EdaNL1hDQUDysNT4CiNDCa8si
        FyhHghmCiXNTk5EU75iQqMiGO5QDaMDLjQ1QPyNs8di9luoyGhPXLOH3g87/5J5X
        uq/RrIH/k5mQtF65L60/vjILl93HaQDUwCxlnIYBE+LxNDIeteaBjpJXDhrU9ov4
        Sbzcfpw1YJFrFSgqDRBvh0+9ZAzq6+EEAJg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id InJvn_3ZvRES for <stable@vger.kernel.org>;
        Mon, 26 Sep 2022 16:22:32 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MbzLb2vf6z1RvLy;
        Mon, 26 Sep 2022 16:22:31 -0700 (PDT)
Message-ID: <225a669c-4907-0473-08ff-30a71813384c@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 08:22:30 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH] libata: add ATA_HORKAGE_NOLPM for Pioneer BDR-207M and
 BDR-205
Content-Language: en-US
To:     Niklas Cassel <Niklas.Cassel@wdc.com>,
        Mario Limonciello <mario.limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        Jaap Berkhout <j.j.berkhout@staalenberk.nl>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>
References: <20220926183718.480950-1-Niklas.Cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220926183718.480950-1-Niklas.Cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-6.7 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 9/27/22 03:38, Niklas Cassel wrote:
> From: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Commit 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as
> board_ahci_mobile") added an explicit entry for AMD Green Sardine
> AHCI controller using the board_ahci_mobile configuration (this
> configuration has later been renamed to board_ahci_low_power).
> 
> The board_ahci_low_power configuration enables support for low power
> modes.
> 
> This explicit entry takes precedence over the generic AHCI controller
> entry, which does not enable support for low power modes.
> 
> Therefore, when commit 1527f69204fe ("ata: ahci: Add Green Sardine
> vendor ID as board_ahci_mobile") was backported to stable kernels,
> it make some Pioneer optical drives, which was working perfectly fine
> before the commit was backported, stop working.
> 
> The real problem is that the Pioneer optical drives do not handle low
> power modes correctly. If these optical drives would have been tested
> on another AHCI controller using the board_ahci_low_power configuration,
> this issue would have been detected earlier.
> 
> Unfortunately, the board_ahci_low_power configuration is only used in
> less than 15% of the total AHCI controller entries, so many devices
> have never been tested with an AHCI controller with low power modes.
> 
> Fixes: 1527f69204fe ("ata: ahci: Add Green Sardine vendor ID as board_ahci_mobile")
> Cc: stable@vger.kernel.org
> Reported-by: Jaap Berkhout <j.j.berkhout@staalenberk.nl>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>

Applied to for-6.0-fixes. Thanks !

> ---
>  drivers/ata/libata-core.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/ata/libata-core.c b/drivers/ata/libata-core.c
> index 826d41f341e4..c9a9aa607b62 100644
> --- a/drivers/ata/libata-core.c
> +++ b/drivers/ata/libata-core.c
> @@ -3988,6 +3988,10 @@ static const struct ata_blacklist_entry ata_device_blacklist [] = {
>  	{ "PIONEER DVD-RW  DVR-212D",	NULL,	ATA_HORKAGE_NOSETXFER },
>  	{ "PIONEER DVD-RW  DVR-216D",	NULL,	ATA_HORKAGE_NOSETXFER },
>  
> +	/* These specific Pioneer models have LPM issues */
> +	{ "PIONEER BD-RW   BDR-207M",	NULL,	ATA_HORKAGE_NOLPM },
> +	{ "PIONEER BD-RW   BDR-205",	NULL,	ATA_HORKAGE_NOLPM },
> +
>  	/* Crucial BX100 SSD 500GB has broken LPM support */
>  	{ "CT500BX100SSD1",		NULL,	ATA_HORKAGE_NOLPM },
>  

-- 
Damien Le Moal
Western Digital Research

