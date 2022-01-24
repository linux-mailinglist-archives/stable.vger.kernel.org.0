Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 354F84996E7
	for <lists+stable@lfdr.de>; Mon, 24 Jan 2022 22:20:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1446256AbiAXVHp (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 24 Jan 2022 16:07:45 -0500
Received: from mail-eopbgr70102.outbound.protection.outlook.com ([40.107.7.102]:61918
        "EHLO EUR04-HE1-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1445064AbiAXVCC (ORCPT <rfc822;stable@vger.kernel.org>);
        Mon, 24 Jan 2022 16:02:02 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jXZxwE+iaWU08z4iRe5DSYJvQlj7E6HnF41MTQYIB43AiQ6e+MA4LEhvyt21yFKENurMJGCnyNJPTcdTYdtpenAXIN2qiPwaLaikd7zpAcW5wUBMBo7r0VkIWiiT7sLdrvYaiBeaYqh+96Lscw2dWHzEdlVPI4ZoJCrN4H67FDxEyg2wfPK6oCZC2ZcAt/4wMjM//buXeoF56RhszQYPnpvlxVIPYa/HDbvZKI14rvxMk5w9AjFVVtMJA6XkL5GEQ808eJEC1x0c4zkAYNzFvpwvDx7S57oxfF/ZjqLai+k4caLuRc4QCOMm+026D0uMO1tmEzrxy41buZr9pe+5uQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=mdBOwHY5CVWUu102K5dLuZCzemwnxloUigYwkHngBKk=;
 b=EMXSZMpsdjoitNEgkcHqbcRcWAS/ZEZm4JHT2N4k3TzhhgmGkIp7Q5CDA/hleGwgy5+RAHF2gWAwUcyJrTUUGS0R5bVY9yYTAxxu2qkFJB1FoEAqVawWmWxfEeBPnnIvXSTrR3OqAzwyeYjMEmfPWXkr3gI9vlMYiQeW+CNiBwhQ7TXBMzV6uk4NuMcuIG0DZxYjBVavXhp1RLDFdsWgzAJaZBlP29TohFWFx2B86m2Yg1Dms33ys3c1hXgIXALdRZ5zO7TXHxVcTBcQ1xXRXCPAv8J1+gppRyQB9w5fCgqWgMCNmWPNy0pEm1qTcXSIzTid3oQ3p5KK3zjcsTAXmQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=temperror (sender ip
 is 217.111.95.66) smtp.rcpttodomain=phytec.de smtp.mailfrom=arri.de;
 dmarc=none action=none header.from=arri.de; dkim=none (message not signed);
 arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=arrigroup.onmicrosoft.com; s=selector1-arrigroup-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=mdBOwHY5CVWUu102K5dLuZCzemwnxloUigYwkHngBKk=;
 b=g7Lddq++RdAc0B/UjOuig42w5gOZKyywsk0f1CZb8h0oun1c09Sb4gdsTCDxZOTJrb8ibBTZjbazcEoBlpjC6Y3FrOMJ7h5ubwca6CrqceumK4ZTs+MEqgJhopgwIfc5KMhFe9dprB07Tnc7+tFvSkqe2U5fsXdQ4AiaTIX97n0=
Received: from AM5PR0601CA0050.eurprd06.prod.outlook.com (2603:10a6:206::15)
 by AM0PR07MB5490.eurprd07.prod.outlook.com (2603:10a6:208:104::27) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4930.15; Mon, 24 Jan
 2022 21:01:59 +0000
Received: from AM5EUR02FT032.eop-EUR02.prod.protection.outlook.com
 (2603:10a6:206:0:cafe::52) by AM5PR0601CA0050.outlook.office365.com
 (2603:10a6:206::15) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4909.8 via Frontend
 Transport; Mon, 24 Jan 2022 21:01:59 +0000
X-MS-Exchange-Authentication-Results: spf=temperror (sender IP is
 217.111.95.66) smtp.mailfrom=arri.de; dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=arri.de;
Received-SPF: TempError (protection.outlook.com: error in processing during
 lookup of arri.de: DNS Timeout)
Received: from mta.arri.de (217.111.95.66) by
 AM5EUR02FT032.mail.protection.outlook.com (10.152.8.109) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id
 15.20.4909.7 via Frontend Transport; Mon, 24 Jan 2022 21:01:57 +0000
Received: from localhost.localdomain (192.168.54.47) by mta.arri.de
 (192.168.100.104) with Microsoft SMTP Server (TLS) id 14.3.498.0; Mon, 24 Jan
 2022 22:01:57 +0100
From:   Christian Eggers <ceggers@arri.de>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Pavel Machek <pavel@denx.de>
CC:     <linux-kernel@vger.kernel.org>, <stable@vger.kernel.org>,
        Stefan Riedmueller <s.riedmueller@phytec.de>,
        Han Xu <han.xu@nxp.com>,
        Miquel Raynal <miquel.raynal@bootlin.com>
Subject: Re: [PATCH 5.4 007/320] mtd: rawnand: gpmi: Add ERR007117 protection for nfc_apply_timings
Date:   Mon, 24 Jan 2022 22:01:56 +0100
Message-ID: <21366142.EfDdHjke4D@localhost.localdomain>
Organization: Arnold & Richter Cine Technik GmbH & Co. Betriebs KG
In-Reply-To: <20220124204148.GB19321@duo.ucw.cz>
References: <20220124183953.750177707@linuxfoundation.org> <20220124183954.021297586@linuxfoundation.org> <20220124204148.GB19321@duo.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Originating-IP: [192.168.54.47]
X-EOPAttributedMessage: 0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 1263f52c-80c4-42e9-cd72-08d9df7cc24f
X-MS-TrafficTypeDiagnostic: AM0PR07MB5490:EE_
X-Microsoft-Antispam-PRVS: <AM0PR07MB54907E96F39000A7CBE062E2BF5E9@AM0PR07MB5490.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:161;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: YTYCkNEB6WyKtse2imyf6fUlsIk2wOX73rFbL3SjmJJ0VXg5IMRrm426GtKDeeURnrMo0VWvEI9J9bm4jEv3qA7iTfoc53rPiZRzx2VYYmIYTanwuRx3spZGfYqil+LJa6zYdf5ZloAlKcH3EkMkPGMrIp5wt/8KVxgI8pphwts6ttdYrgVUsee4yTR8b2LV1FMciN7Y91OW24A6sjZS4hKN8JsV+h2a7xZ8dFeB7GGADk4yWNGFF8fYz9aPeJvtpQWsrc119IsrgRHJZ18HAzjdUAfKXXDE9pZ5Q96J1kaHVod1LISCaB+sEN4eRCmGbwr0dSgn6vasgmcpobDK2UEUC6OwoSMKR60Mwi1t9uNDkUmSDEc2Ujhi/cKMp/lQfEYeYFitBXa3DdJFT85u089L6kZ2vg4GacPp21EhpWr1JeVZnCSdTwrSsBZQ9syUmrDuwfUdSSOd67CUaYMNLJUWEKUjO+M4gTHwxWn+FTKyQ35r+cyfEFmKm6qmQeQMUPcpxkhqmJRrYa1KrOUxZdrgvlt+taQLHUHI5QttsrQLAPMpzmfoGdY2Z3JeNw6rI3YsrGMIke0Ook5dOOC236xfmdEKLjXRjbIv3o0MRlEhx6CmYzqmlrTsQCeVCblzh5MSQbQ+3NDWp/H1RR7wt64XX3l/UdBO5IJ9dK0oqjhIFtjxsCybcVzRD+XuPGfDfNAA6yzAPvj4DzQEmqIQ1kRxD+ZASBGTioRqUIpgXK9fuSoK4tdHcdZgv+YLO0yk
X-Forefront-Antispam-Report: CIP:217.111.95.66;CTRY:DE;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:mta.arri.de;PTR:InfoDomainNonexistent;CAT:NONE;SFS:(13230001)(4636009)(40470700004)(46966006)(36840700001)(508600001)(316002)(4326008)(8936002)(8676002)(82310400004)(83380400001)(81166007)(356005)(54906003)(47076005)(70206006)(70586007)(63350400001)(450100002)(110136005)(36860700001)(107886003)(55016003)(36916002)(40460700003)(426003)(336012)(186003)(26005)(16526019)(2906002)(86362001)(7696005)(5660300002)(9686003)(39026012)(36900700001)(20210929001);DIR:OUT;SFP:1102;
X-OriginatorOrg: arri.de
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 24 Jan 2022 21:01:57.6240
 (UTC)
X-MS-Exchange-CrossTenant-Network-Message-Id: 1263f52c-80c4-42e9-cd72-08d9df7cc24f
X-MS-Exchange-CrossTenant-Id: e6a73a5a-614d-4c51-b3e3-53b660a9433a
X-MS-Exchange-CrossTenant-OriginalAttributedTenantConnectingIp: TenantId=e6a73a5a-614d-4c51-b3e3-53b660a9433a;Ip=[217.111.95.66];Helo=[mta.arri.de]
X-MS-Exchange-CrossTenant-AuthSource: AM5EUR02FT032.eop-EUR02.prod.protection.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Anonymous
X-MS-Exchange-CrossTenant-FromEntityHeader: HybridOnPrem
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM0PR07MB5490
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Pavel,

On Monday, 24 January 2022, 21:41:48 CET, Pavel Machek wrote:
> Hi!
> 
> > commit f53d4c109a666bf1a4883b45d546fba079258717 upstream.
> > 
> > gpmi_io clock needs to be gated off when changing the parent/dividers of
> > enfc_clk_root (i.MX6Q/i.MX6UL) respectively qspi2_clk_root (i.MX6SX).
> > Otherwise this rate change can lead to an unresponsive GPMI core which
> > results in DMA timeouts and failed driver probe:
> ...
> 
> > @@ -2429,7 +2449,9 @@ static int gpmi_nfc_exec_op(struct nand_
> >  	 */
> >  	if (this->hw.must_apply_timings) {
> >  		this->hw.must_apply_timings = false;
> > -		gpmi_nfc_apply_timings(this);
> > +		ret = gpmi_nfc_apply_timings(this);
> > +		if (ret)
> > +			return ret;
> >  	}
> >  
> >  	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);
> >
> 
> AFAICT this leaks pm reference in the error case. Not sure what
> variant is right, there, so...
You're right, thanks for pointing this out. I think that the error path
currently should not appear in practice, but I plan to add further patches
in future where this could happen then.

Although there's a potential new error, I think that this patch should
improve the situation.

> 
> Best regards,
> 								Pavel
> 
> diff --git a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> index 1b64c5a5140d..06840cff6945 100644
> --- a/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> +++ b/drivers/mtd/nand/raw/gpmi-nand/gpmi-nand.c
> @@ -2284,8 +2284,10 @@ static int gpmi_nfc_exec_op(struct nand_chip *chip,
>  	if (this->hw.must_apply_timings) {
>  		this->hw.must_apply_timings = false;
>  		ret = gpmi_nfc_apply_timings(this);
> -		if (ret)
> +		if (ret) {
> +			pm_runtime_put_....(this->dev);
>  			return ret;
> +		}
>  	}
>  
>  	dev_dbg(this->dev, "%s: %d instructions\n", __func__, op->ninstrs);

I'll prepare and send a new patch tomorrow.

regards
Christian




