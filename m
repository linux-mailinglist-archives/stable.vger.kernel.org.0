Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 78A60632774
	for <lists+stable@lfdr.de>; Mon, 21 Nov 2022 16:11:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232083AbiKUPLh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 21 Nov 2022 10:11:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35406 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232098AbiKUPLD (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 21 Nov 2022 10:11:03 -0500
Received: from esa1.hc3370-68.iphmx.com (esa1.hc3370-68.iphmx.com [216.71.145.142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EED7D5391;
        Mon, 21 Nov 2022 07:03:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1669043032;
  h=date:from:to:cc:subject:message-id:references:
   in-reply-to:mime-version;
  bh=74gGC/+XVntRJWZO1FWJrYsJ1OH7xIwi7wtWaUh3H3E=;
  b=fTvQu5VWEjNZ9ww6+IPCe3BaBBPKKB5IPQA86/KFk+aZXMU8k3J+b7D0
   5NIfkc3v8tiDP3ijb0jzmPH5tCSwBp9KA+rKp65t84pKXAVYRKwFDAs5v
   4OIK956DO+3ODaMNM0PYKNk38WUJz/08r6XiMNtV82Cj01k2Sj+J8VYZz
   E=;
X-IronPort-RemoteIP: 104.47.73.170
X-IronPort-MID: 85678752
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:vKkMAKp8vC6UcC6DWx1Tr57i+wheBmI0ZRIvgKrLsJaIsI4StFCzt
 garIBmEM/feYGf3LtB3a4Sx8UMO6MPXmNIxHlNrqnw8QiIa8ZuZCYyVIHmrMnLJJKUvbq7FA
 +Y2MYCccZ9uHhcwgj/3b9ANeFEljfngqoLUUbKCYWYpAFc+E0/NsDo788YhmIlknNOlNA2Ev
 NL2sqX3NUSsnjV5KQr40YrawP9UlKm06W1wUmAWP6gR5gaHzSBNVfrzGInqR5fGatgMdgKFb
 76rIIGRpgvx4xorA9W5pbf3GmVirmn6ZFXmZtJ+AsBOszAazsAA+v9T2Mk0MC+7vw6hjdFpo
 OihgLTrIesf0g8gr8xGO/VQO3kW0aSrY9YrK1Dn2SCY5xWun3cBX5yCpaz5VGEV0r8fPI1Ay
 RAXAAIrNhKbp+Lp/LyYCfI2us8SfZbQN5xK7xmMzRmBZRonabbqZv2WoPpnhnI3jM0IGuvCb
 c0EbzYpdA7HfxBEJlYQDtQ5gfusgX78NTZfrTp5p4JuuzSVkFM3j+OraYWNEjCJbZw9ckKwv
 GXJ8n6/GhgHHNee1SCE4jSngeqncSbTCN9MS+3nq6QCbFu7ykMeOhkseEqAp+jn1kuYdu0YF
 gsJ5X97xUQ13AnxJjXnZDW6qnOZuh8XW/JLDvY3rgqKz8L88wufQ2QJUDNFQNgnr9MtAywn0
 EeTmNHkDiApt6eaIVqf+a2TtiiaIjUOICkJYipsZRAZ6tPnraktgR/VCNVuCqi4ipvyAz6Y6
 zqNtiklwbIIkdQMyb647HjAmTunopWPRQkwji3LUWa1xgd4YpO5fYuu6Eid4fsoBIOYSFaGl
 GIJl8iX8KYFCpTlvCaVaOwJHbyvt7CJPVX0jVdxEt8h/jK29niLeYFW/SE4JUF1P8JCcjjsC
 GfD6V1555JJOnauK6htbOqZC9wj5brxCdP/EPvTa7JmeJF/fQKD1CJjf0id2ybqikdEuaUyP
 52zcsu2C3seT6N9w1KeQ+YbzK9uzysmxEvNSp3hiReqy7yTYDiSU7htGF+PaP0pqaCJugPY9
 /5BOMaQjRZSSuvzZm/Q64F7ELwRBX0yBJSzrtMNcOeGelZiADt4VKeXxq49cYt4magTjv3P4
 ny2Rk5fzhz4mGHDLgKJLHtkbdsDQKpCkJ7yBgR0VX7A5pTpSdzHAHs3H3fvQYQayQ==
IronPort-HdrOrdr: A9a23:Co7Uy68SM1lXbmLEKJ5uk+Gydr1zdoMgy1knxilNoENuH/Bwxv
 rFoB1E73TJYVYqN03IV+rwXZVoZUmsjaKdgLNhRItKOTOLhILGFuFfBOfZsl7d8mjFh5VgPM
 RbAtRD4b/LfD9HZK/BiWHXcurIguP3lpxA7d2uskuFJjsaD52IgT0JaDpyRSZNNXN77NcCZe
 2hz/sCgwDlVWUcb8y9CHVAd+/fp+fTnJajTQ8aCwUh4AyuiyrtzLLhCRCX0joXTjsKmN4ZgC
 P4uj28wp/mn+Cwyxfa2WOWx5NKmOH5wt8GKN2QhtMTIjDMjB/tQIh6QbWNsB08venqwlc3l9
 vnpQsmIq1ImjvsV1DwhSGo9xjr0T4o5XOn4ViEgUH7qci8YD4hEcJOia9QbxOcsiMbzZhB+Z
 MO+1jcm4tcDBvGkii4z9/UVytynk7xhXY5i+Ycg1FWTINbQr5Mqo40+l9TDf47bVTHwbFiNN
 MrINDX5f5Qf1/fR3fFvlN3yNjpZXg3FgfueDlxhuWllxxt2FxpxUoRw8IS2l0a8ogmdpVC7+
 PYdox1ibBnVKYtHO1ALdZEZfHyJn3GQBrKPm7XC0/gDrs7N3XErIOyyKkp5dutZIcDwPIJ6d
 j8uWtjxC8Pkn/VeI2zNMUhyGGPfIz9Z0Wh9ihm3ek2hlWmL4CbcxFqSzgV4ridSrskc4jmss
 2ISeNr6s/YXBTT8LlyrnPDsrlpWAwjuZ4uy6IGcmPLhP73AavXkcGeWMrvBdPWYEYZsyXEcz
 E+YAQ=
X-IronPort-AV: E=Sophos;i="5.96,181,1665460800"; 
   d="scan'208";a="85678752"
Received: from mail-mw2nam04lp2170.outbound.protection.outlook.com (HELO NAM04-MW2-obe.outbound.protection.outlook.com) ([104.47.73.170])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Nov 2022 10:03:48 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=mltunTYnAUfU4WRY+IRVktXiyg8yYenRpZ3mKWu2qBGADQV4ebaAo1g96O0V5aXb1PJc1fJQzTJP49WR5CR9l8DbMQlxnB26UanmTdObHcTlA1Vaho6B6pNNklQNhezGk2LG1xNaHUNop+jaySdj+XEQvCPyRoyZ+O9z91WZ22u9Ko+In65LM/p+0gXNfDC64wwiFf7gpDlhV6TS0giFVCqeJITMVmgogm33l0txZHBYLarFuCXFxqRCFXRpEmXk2WiGMhQO8soXZEmKwEDRwbmzYp4OublReI15pQzjfEEaLqPjFr2r9RA3ZOKBErG3T+fxQp0mIVgrG6kXwHO9Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=G8kEk6AAysY2z/E7re01QoqsHZRMQRyyh0Cgrhc6VtM=;
 b=YXwt5N0W8JZ3pFcDBSlL/DqLrT84lJrpO9Hq21xWd2rojQYqYsIfE7Np5S6ZXAHBT2csBDj2mmnKCIqcxT+HuElhFJK6VeZ+Xz+aBZhzFt07XP8PwAkavudD4O6lLcR/5QrjgmPetwHi+m078ShmqHzliDaYVGkcLly2bGAyX3cWKIK1Z4Ze3J21+0AfBnNng5VMCJXgPprbFwoyvVpjzSfTBMbU+hnWr6l2zIn6xOgXc6q9xWcFVvOIIcFfsA3lt9uNUW7H0RMPQZ/5xslk3i7/lb+tSyldXXnz3hoY1mHpSkQNMXaZ51cukEkbIakdjsMxw2a8SHMKyV+XlcFqcQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=G8kEk6AAysY2z/E7re01QoqsHZRMQRyyh0Cgrhc6VtM=;
 b=gN7SD/xaTy0TOyu765GUUterW9xJdHu7JtC+PnU07shzyqQHVkil7lS/3rwEWJiSUy/UkdJI1XdU1doCnEsFzyNOiHOZmlHOXaMNzuS9CA+kmf/RBYseTYKSl/ntAkkI8nS8zeel9ngrYlEpboU4Z9bTkTvABB1qM/AqHjokjQM=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
Received: from SJ0PR03MB6360.namprd03.prod.outlook.com (2603:10b6:a03:395::11)
 by BN9PR03MB6044.namprd03.prod.outlook.com (2603:10b6:408:119::14) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.15; Mon, 21 Nov
 2022 15:03:45 +0000
Received: from SJ0PR03MB6360.namprd03.prod.outlook.com
 ([fe80::740b:4e0a:7de4:5ab1]) by SJ0PR03MB6360.namprd03.prod.outlook.com
 ([fe80::740b:4e0a:7de4:5ab1%7]) with mapi id 15.20.5834.015; Mon, 21 Nov 2022
 15:03:45 +0000
Date:   Mon, 21 Nov 2022 16:03:40 +0100
From:   Roger Pau =?utf-8?B?TW9ubsOp?= <roger.pau@citrix.com>
To:     Jan Beulich <jbeulich@suse.com>
Cc:     xen-devel@lists.xenproject.org, jgross@suse.com,
        stable@vger.kernel.org,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Dave Hansen <dave.hansen@linux.intel.com>, x86@kernel.org,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] acpi/processor: sanitize _PDC buffer bits when
 running as Xen dom0
Message-ID: <Y3uTTAWxe/676t3q@Air-de-Roger>
References: <20221121102113.41893-1-roger.pau@citrix.com>
 <20221121102113.41893-3-roger.pau@citrix.com>
 <bac0ed0f-6772-450b-663c-fc0614efa100@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <bac0ed0f-6772-450b-663c-fc0614efa100@suse.com>
X-ClientProxiedBy: LO2P265CA0110.GBRP265.PROD.OUTLOOK.COM
 (2603:10a6:600:c::26) To SJ0PR03MB6360.namprd03.prod.outlook.com
 (2603:10b6:a03:395::11)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: SJ0PR03MB6360:EE_|BN9PR03MB6044:EE_
X-MS-Office365-Filtering-Correlation-Id: d31ff563-3920-49c6-8835-08dacbd195f9
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: qXL89dQwxDeP2RA6Lk0o0+iLmmOSLBx/kimYmb7j/s2XvHOeoYCJNRxfsh0Cm8ye7wqMDEncV23iYM+H330CAT5G8blJe+BdRY5Oolw07ZHWxYL9zIlSENNRtMh/YRkf1m1CSUpLBv+blV7v36er8VoYxGJ1btLwzSLtrHig796i+5cOEL3goGHjXCkh20CTrjHh8WTXvOnpTnxW12LFYq5+NKkHC1jJL834jP/fgLvk2JolsJJ895BRfx+dSbfXCDmSPodtLhX9989TzSwjX7ZP0HhpF66uYuBa7jeigsS0AB2ANM/R09Z7FM7S2JCC5ptuf/P+ghwgK6c4GY1BxERUFpjMpSV3TSidBcVWvabiwcjIy0Q96pU7B3/6R9AJ87g8QUhN3Dy8MjSrYG251R+83x6RUkJx8L0O5onlqnifbZy1G+NW2YQhdLJ1i1HLIOvsiX4vvbT3A0D6kKoLUk3Cnz0/33hsdjE1FaPRt7rvHG4E8KuJ+tVHOGnUy9P1wHEzAe5In1CedF9EaBXZRkfosfoBA10bjzHCU7ZHzdFtqbBoyIndHwGdgMZEssoGJWRHUVw92VJBjiihmKEz1jicBEvUGJ68jYmX9MIvCsxbMFN/XWVS/OHmgeHXAbPpDuOM6X1giJb2v/Cx4lB48g==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR03MB6360.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(7916004)(396003)(136003)(39860400002)(346002)(366004)(376002)(451199015)(82960400001)(38100700002)(33716001)(26005)(86362001)(6506007)(478600001)(6486002)(53546011)(7416002)(6666004)(5660300002)(8936002)(4326008)(66556008)(8676002)(66946007)(66476007)(41300700001)(316002)(186003)(2906002)(54906003)(6512007)(6916009)(83380400001)(9686003)(85182001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?TWV4aVRjWm1TVEs0cGovVVBmdmQ5cHdiUmwrOXNYK1doZG1EcE4wVnhDSHIz?=
 =?utf-8?B?TlFYL2x1ZkF3RkVwNVJaak9ST2FuKzMxZDAvckdBUFhtZ1BLL05USmRpcHFh?=
 =?utf-8?B?Z1lYZitrTGppRUQ2SnB6M1hQVzE1VEVqbEFKczdMTWxSZzNHR1N6enhyNUEy?=
 =?utf-8?B?SGF2NjF5YnNtdDVuV3RZSUR2a0wvVHJwaWpubUxoUmZyS0FSSmtId1BQWHY0?=
 =?utf-8?B?Zll3Sndab0txSVo4TUZmNEVDUmRqbEl0ejJNS3Q3UGlzY0t3N3Nlai9oM01W?=
 =?utf-8?B?dWgxaDNDZUpSaTQwcFZwaHVsZ2FYRmxPcXFIK0VEQkFNVzVTS1B2NjFyVGxp?=
 =?utf-8?B?WmlIeUtkVnNoTWFHR3h1cUszSjlBdXEvczR6Q0pWV0Z5QStIKy9HcjltajFo?=
 =?utf-8?B?WmNWd3l5V0xYOUhJcWNtSFlHWXRRYVREYVNLT0g4VW1sbnFUUFMrdE40bWdl?=
 =?utf-8?B?V1YwK1MxSVlTRExqdzdRQ1ExMU9GY0Rpbzk0SGZwaXNhZThuaXl4dFcwNzhr?=
 =?utf-8?B?cko0VUd1TUlGTE0yOGNnTGpzaWhzcmlieEV3Wnh3c2NTOVViYzVqU2oxenJ1?=
 =?utf-8?B?RUsvajFFMVFuaTJqeVFnVVZjb0RtOVdrVnhlUEFyZmdpNDEwUmNmOGlIcGtE?=
 =?utf-8?B?VkdHTlBtYURKckRyc0dwRDhUS0pUTVQrS3VOY0UrdVBVUnRDdStVSExHMEZ4?=
 =?utf-8?B?d002SFFnZnpHaVd6eVFoRW9IaDhHRDZyNXdUaGVSd094UXpzaVAvZWdQcjhq?=
 =?utf-8?B?KzdxVGhkWEc0WS90aGxFdnFFelh0N0ptTHZLWnBXcXJUNVVzbUx0TjJScThO?=
 =?utf-8?B?VXdUWXBqdkhENFNMUnZwSmtXUzJ3d3JQNjQ5aXloUXdERkEzS1plR0N0OWcx?=
 =?utf-8?B?eWhCTlJSVEF3R0pQYVh1ZWo0VFhaZlV5a0RBa0VpclVZYW1MZEhoa2IvY0Fk?=
 =?utf-8?B?QXdZanVKRHBoY0k1cE5TNFg0OGFJNktZLzg0VXpRNVVaSXRlYmNPYzRHcmlQ?=
 =?utf-8?B?QjdyZTBlMDFkYmlER3BqYytURGFKWVpscURZSzFORjBkSlpwQ0szSFAwVWRq?=
 =?utf-8?B?amQwY25VbDdzYUlPaXVXbXhXQWorTTBqcnlIRk9JU1ZZVHYyQ3RJblREaXd4?=
 =?utf-8?B?elg1b3pDb05ObUkyWThuYmpSSjhMeDVsQVJ0QklvbmNuZi81eXFWVzJnQzZO?=
 =?utf-8?B?Y0tyYTZTR2ZPN3dORTFVUk9rZ1BBbUVjNENnWUZ3cDd5aEtPNjBTVGo2elha?=
 =?utf-8?B?anhWdFpVcEJkSmJldlRVcFJBT3MwQnBWcEFRNXN5U0xsby9wY1FSajZzTmVm?=
 =?utf-8?B?OFZ0NDlnRXFMZWo1VUV5TTRqOUg1eTJMay9KeHJ0bGJiTVVWdXcxOVRUNmRU?=
 =?utf-8?B?TUZLbGpicjgrNU92K2dpZldrNnNScEZWYS9OVExsOGQwbVUyRGlMUEVXajNu?=
 =?utf-8?B?d2FFeHMrUkhYSFJHUEQxVWlSSGdqeXR1N3VERVd1WXFoeGRETGxVNTlVOGRM?=
 =?utf-8?B?cERoUDJZRmJiRGhvS1NpaWIyUCtXMmU4RklaN3hDRGNnN2JYUnVrYUhCWnFo?=
 =?utf-8?B?RGpjWVlFTnlUcm15VmxVTm5HeUlSZW9MSmFTWUtaeHpFR2VFQWJ3MTBsMlpW?=
 =?utf-8?B?bTlxRWJiby9IcS9DdTk0SjVTWlpJeWJIeVRqTjBrZTh4UVZNYWxrUWdycXZr?=
 =?utf-8?B?aXJDZjFNSWNsY1dIekd0WitTSzJlak1mdG1rdy9FYzBQUW10RGN3TEUxRGVj?=
 =?utf-8?B?UzFqRlFFSHRqZG1zVXJ5NXlINTIweUMyeTRxZU1rRU1Cbk9DaXFqUzhrQTR3?=
 =?utf-8?B?MzdzZmNxZTB2RnlOQmRRdjllenRLOUZRcyttTVJZWjJweUFZbURQajkreG1Y?=
 =?utf-8?B?VEhEN2o2eFI5L2FPSDdzejJZMDA3bGVlU243WmtIVVh2VjJlR1R2d1FVVkxR?=
 =?utf-8?B?MTJjclprTHFUa3FicUt2Y05Xc1BUbERKdTZ0cWppdnVmSTZybXB2a1U1Y3hT?=
 =?utf-8?B?Z2xzWCtiTDJaWkdJTkRKSE16bjY0UDZvdU0xRUpPZURhMGh0dmdIY2piYTMy?=
 =?utf-8?B?VTQreEJqKzNnMnJlSHEvdGZtWDNZOGlwOEVYR1gwcXJmeGZBT2VMRzVuUkpR?=
 =?utf-8?Q?XsL3eq57KFADOErNtuR6PX7c/?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?d3F2RXVDL20yY0JNNmdWL0NSYXp6MitnN0phaDRyYm5Fd0JiblJmcVhtOXMw?=
 =?utf-8?B?VUYzNEVFbEhyakZSdUM5clVrNi85dUcwcTJsN2J4MnRQOGNwUFBqNHV4WkZ0?=
 =?utf-8?B?bEFGb0p3UlJKTnIxVVEzMzhnQW9oWW9NazBnZmlFMWIyZWlnbXVoQmhjWDZ5?=
 =?utf-8?B?S1JKWXpyUlJueWRYM1hLcmIxYzJXK2xVS2l3SHBWaWYxdFlpbmx2L3R6RmZN?=
 =?utf-8?B?bEZOdWJjV0FqRGVqZjZ0Z0Zia3oyZ1VZdDVWaWJTVnNjeFhJNmZrbUxuYjJs?=
 =?utf-8?B?ZFVnd2hvalJWRDVmSDNLVnlXYmNDQjZGaUNpMXUxdFJnZTNUZTcyMVhPOVVx?=
 =?utf-8?B?d2diRFVuL25way9XbHZMYVA2L0o3RFduQzlxUmY1UTc1MG5oMzNSVGpXN3NB?=
 =?utf-8?B?QzE3MHd1ZjBTa252TE1JUnl3TE1ScUdkdVNIZmtxT3ZYUkdGanlvdUxsNFRM?=
 =?utf-8?B?Q1FUS21lNm1Gc29tMHJlaHVaaW5ZcGRIajYwbC9aL2dWNG4rK0NIajZETW1Y?=
 =?utf-8?B?dDJ5eVAwWkJvY1AwYkRuMDlvc0xHRUxvRCt2Q1JzOFlUcW9QMjJMQjNrYUpC?=
 =?utf-8?B?clJLS255OUpZSnRhQUhsV0pwOElmME1abXpGTHgrcjBsNkZ2WCsxekNJeSt4?=
 =?utf-8?B?eTNmMDBGaUtheVdhZS9aVlh6d1JWc2drSmM1N29EczNBb05Eai8ycTZDVVB3?=
 =?utf-8?B?ZWRSVHpyUHZSa0RmTVVrekVSczM2ZWpRUlhQcGFJZ014dXEwV1BYNHZlWlpt?=
 =?utf-8?B?Nm54Qk5IMUlnUEFiZ0tINVM4ZE8wOG9ZVHpGNXViRVoxamlMRHN6NkFMQ2lG?=
 =?utf-8?B?UmRkL3RGZzF2UjVOTC91OFlqM20vWEg3RGt2cFBWRjZ0d08wNjJQOFhFWW4z?=
 =?utf-8?B?Qkg0UTRJSHBmUEh0S0p2N014ZXlQRGU1aUw5UmVMRlMzbEt0bExUaVB3VFRD?=
 =?utf-8?B?ei9GTVVuamlVM25hV1hNTEVtK1pGV0xKcXJJZytUVnIyUDAza3ZaanpHRElT?=
 =?utf-8?B?Z1N0QjZGaWZRSzhYSDJ5QjdtbjU4MHZ2ZzFUS2p6V3l3WFFzdWFvVWdyQnY3?=
 =?utf-8?B?N01OV0tOVlphckEzcFZLTHJ5WW8wMnRSWXQ1S3FKMDB2Y1liRlBOZXFObzNP?=
 =?utf-8?B?bXJZcVE4aFhvZ1Q5WjNheVdZdWFkVVVVQ2N4N1FUcG9KbXBacWdpYkRyK29H?=
 =?utf-8?B?RGpRcjZNSVJXS0wzdGdiQWhENXFXak9wWGlLc1REU0pzd2w4Uy8yQmtIdzh0?=
 =?utf-8?B?M2c3N3RzRUxSM1pnZ2FRNFVjZGFHTWlGZ1lhOTRCRmhGS3liWFFVUGUrMXk1?=
 =?utf-8?B?bXV3eEp0UEpwUHMrZzRsQ1liTjhKcmI2NTVTcnhLOWFWMlFsUUo3dU9xNmIw?=
 =?utf-8?B?SFBDREdpaHphenFINDBudlA4ZC9ja2xqVFJvVDBBOFF4cTlYSGhqRDN6b2xV?=
 =?utf-8?B?dXZuZ0xJQkF1RVpmVFZHTU9PL2VjeVBKVUFIaVhoamYzSHpWaDEvdXNDelV5?=
 =?utf-8?B?QTMzTkpwaDVpUnI4RWg1cy9XeVdCNVd5djRQdFBzZGt0c29XMjg1WDVhY0tJ?=
 =?utf-8?B?VVQ3b0QvT2psV09ZVjNiciszcGxKVWZpWEZMY0lXWlJlOXlQRERiSGZiS1RE?=
 =?utf-8?Q?YcatSdlcU72rUzeZ0H5cYLfdZjXvZcg2P2a/oOXyiTeI=3D?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-Network-Message-Id: d31ff563-3920-49c6-8835-08dacbd195f9
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR03MB6360.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 21 Nov 2022 15:03:45.3306
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fs4TE4RXe+NAUmO3NF2xJXkNcPkdC9m9Z+q4u0tl5vOLp9UraRBfv9BrS6yYEZP8m8IcMsEembGfcj2dkO7Eeg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BN9PR03MB6044
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 21, 2022 at 03:10:36PM +0100, Jan Beulich wrote:
> On 21.11.2022 11:21, Roger Pau Monne wrote:
> > --- a/drivers/acpi/processor_pdc.c
> > +++ b/drivers/acpi/processor_pdc.c
> > @@ -137,6 +137,14 @@ acpi_processor_eval_pdc(acpi_handle handle, struct acpi_object_list *pdc_in)
> >  		buffer[2] &= ~(ACPI_PDC_C_C2C3_FFH | ACPI_PDC_C_C1_FFH);
> >  
> >  	}
> > +	if (xen_initial_domain())
> > +		/*
> > +		 * When Linux is running as Xen dom0 it's the hypervisor the
> > +		 * entity in charge of the processor power management, and so
> > +		 * Xen needs to check the OS capabilities reported in the _PDC
> > +		 * buffer matches what the hypervisor driver supports.
> > +		 */
> > +		xen_sanitize_pdc((uint32_t *)pdc_in->pointer->buffer.pointer);
> >  	status = acpi_evaluate_object(handle, "_PDC", pdc_in, NULL);
> 
> Again looking at our old XenoLinux forward port we had this inside the
> earlier if(), as an _alternative_ to the &= (I don't think it's valid
> to apply both the kernel's and Xen's adjustments). That would also let
> you use "buffer" rather than re-calculating it via yet another (risky
> from an abstract pov) cast.

Hm, I've wondered this and decided it wasn't worth to short-circuit
the boot_option_idle_override conditional because ACPI_PDC_C_C2C3_FFH
and ACPI_PDC_C_C1_FFH will be set anyway by Xen in
arch_acpi_set_pdc_bits() as part of ACPI_PDC_C_CAPABILITY_SMP.

I could re-use some of the code in there, but didn't want to make it
more difficult to read just for the benefit of reusing buffer.

> It was the very nature of requiring Xen-specific conditionals which I
> understand was the reason why so far no attempt was made to get this
> (incl the corresponding logic for patch 1) into any upstream kernel.

Yes, well, it's all kind of ugly.  Hence my suggestion to simply avoid
doing any ACPI Processor object handling in Linux with the native code
and handle it all in a Xen specific driver.  That requires the Xen
driver being able to fetch more data itself form the ACPI Processor
methods, but also unties it from the dependency on the data being
filled by the generic code, and the 'tricks' is plays into fooling
generic code to think certain processors are online.

Thanks, Roger.
