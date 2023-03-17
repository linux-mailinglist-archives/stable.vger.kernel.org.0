Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE57F6BEE25
	for <lists+stable@lfdr.de>; Fri, 17 Mar 2023 17:27:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229608AbjCQQ1k (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 17 Mar 2023 12:27:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229499AbjCQQ1i (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 17 Mar 2023 12:27:38 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D915E5039;
        Fri, 17 Mar 2023 09:27:10 -0700 (PDT)
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 32HGEjka004686;
        Fri, 17 Mar 2023 16:26:50 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=Fh1MSqVerPO5qyojfa5eXZu6Knu8qU2J9pF6u+wFHkQ=;
 b=cmogIygdVE7xXF+GdSyEO9IWG/mkPtJbv4xSI7H0rRUUqqrCb+9X6eRHtzEuabyf0X4z
 SMuapfhpms41El/E5jh2xKFUuIy627kHqoQrWIE/IS8HYibF7yOrAGtRHs8Q6cjDUf18
 oD5zutZW7zQ5NL2p2mhOWkGCW9wIK/7SIzGc03V4fYmcSCowwKxVVSVg8Xy9KPea9XxR
 fTzwS7YZQC1TnQKxbRQ8GVmA1wY8hKeLh66pWeF3g4dBjLDH4pGQIG6lyIj3KuoZ55Ty
 cOsWgL+wB/p+7iuAXFlLijoc3tlHiuxRHg61NPmtszOzspwBK7hD41Cst1TCoBQAUKGV Pw== 
Received: from phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta03.appoci.oracle.com [138.1.37.129])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pbs28m9nq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 16:26:50 +0000
Received: from pps.filterd (phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 32HFfqMI015703;
        Fri, 17 Mar 2023 16:26:49 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2042.outbound.protection.outlook.com [104.47.66.42])
        by phxpaimrmta03.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3pcu2u1pnc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 17 Mar 2023 16:26:49 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HXgXSWxnRkrYxjOOeGuxS0XElPLpqB+r2dDjirN1YDNjwHWXE+6sqnoyRDSJKKBmQyOJR9ntGB+dImDTxd4G6FCAEZGIcyIYqLEnSWxoD0hnWJHYY6KZbGZx9F19jf5LvkluI6pOyt0WcMxtb5hZxO3aABj6/j4j/rUa8Dc5LJ01UynPUk2biE+0us9B91QjSqgp4G/ASas4mJXk72e6T4B5O2KmUFQ/RYHUIZxfvXSDMnuLE3L9obs7slHcgPv3k4ROcgUsg9sZniZDlxt9EJFIG9RJe5VNX4kerNewb3n0sl0wxMS9xAGyGHeYJG4ZdK8UHKNr2HFcPNaCOg9lIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Fh1MSqVerPO5qyojfa5eXZu6Knu8qU2J9pF6u+wFHkQ=;
 b=cLFbqSkjNW0nkqZitMPYcJmlXwR5avPuwzpR3GfRclfHxlwv+BvgULwM7mRmg9Qk6aRzy2pVEx2i3kX3YZOUOehXmenGnsq0bob8Hxmr3UBB2hh4TA17/grThPPQJrE04FAM0i+sk1LlLvu0z9Ig6HhbKu7jojKxpdyOy5TBBmdEDa2mQCCn+DgBOJNd11nBMQFjUbv/R3H7AJ65sz4BCTlIc1jAyo4WCMIbBLLuBfqCkgG3dXRxuAUKk7rTgbyzPOnYjT9aKTDd/jef2cMMrvuHLUQBc+av0Mg6FqWx79esMhS04zeXNmb8cc6LA5VUIa6BbzmQ2M0KAW+dEixZeg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Fh1MSqVerPO5qyojfa5eXZu6Knu8qU2J9pF6u+wFHkQ=;
 b=rNNhIt4woBOumVH4EN4XoOlm8Ihj5Q0DVoQMmwT7B45d73NAK2t/aWT2imxx8AC6bzjb/WGbjxLxxD0Znu42pEJ9fzk/5+l5aVZSwt1C1awxvs3GZXd9UXvmUnY1glnQ9gr/aWJl1khACdjeByOKDzIMX5si7dNYceUorEnDqXI=
Received: from DM5PR10MB1419.namprd10.prod.outlook.com (2603:10b6:3:8::16) by
 SA1PR10MB6616.namprd10.prod.outlook.com (2603:10b6:806:2b6::9) with Microsoft
 SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.6178.31; Fri, 17 Mar 2023 16:26:47 +0000
Received: from DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::df32:94e7:3f41:97ef]) by DM5PR10MB1419.namprd10.prod.outlook.com
 ([fe80::df32:94e7:3f41:97ef%7]) with mapi id 15.20.6178.035; Fri, 17 Mar 2023
 16:26:47 +0000
From:   Saeed Mirzamohammadi <saeed.mirzamohammadi@oracle.com>
To:     Pankaj Raghav <p.raghav@samsung.com>
CC:     Christoph Hellwig <hch@lst.de>,
        "# v4 . 16+" <stable@vger.kernel.org>,
        Keith Busch <kbusch@kernel.org>, Jens Axboe <axboe@fb.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "javier.gonz@samsung.com" <javier.gonz@samsung.com>,
        "k.jensen@samsung.com" <k.jensen@samsung.com>,
        "jh.i.park@samsung.com" <jh.i.park@samsung.com>
Subject: Re: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung PM173X
Thread-Topic: [PATCH 1/1] nvme-pci: add NVME_QUIRK_BOGUS_NID for Samsung
 PM173X
Thread-Index: AQHZV45nokIbA+QLzEKTFICk+DnoIq783W8AgAEQ1ICAAOTMgIAAWFwA
Date:   Fri, 17 Mar 2023 16:26:47 +0000
Message-ID: <3B7AB643-C87C-4C19-A47A-C15565750243@oracle.com>
References: <20230315223436.2857712-1-saeed.mirzamohammadi@oracle.com>
 <20230316051508.GA8520@lst.de>
 <930CF361-37C2-4625-B5FA-245248544F92@oracle.com>
 <CGME20230317111849eucas1p115741dc29cc0a5c57914e60aa5216288@eucas1p1.samsung.com>
 <20230317111031.lygazqsaeekpdegd@blixen>
In-Reply-To: <20230317111031.lygazqsaeekpdegd@blixen>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3696.120.41.1.1)
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM5PR10MB1419:EE_|SA1PR10MB6616:EE_
x-ms-office365-filtering-correlation-id: f19a9ca1-6d93-45a9-dc3a-08db270467b8
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: zJOpVCOXNPYtgIGY7PDbIk3QOs4dbGOG5CrDeGaekD/7GtiAAB9lXE3kBrMjl0pWhILnWvmBrcsjetApeXiUCwP9jAcU6mBFuysbZXNJhW0rEUTVInlUTPEA+y8NQGvciktbs67lfQregMgKRR4xuN8w3h9W4jmulPFf00/mvvvB9UPL4A/vqop5XfGp400j1CDtsf3ZU3tWUMaJyWRC/I/gxvUONHXJ7/U87dqci8hYgSEiEA+wea7BwT+ZuGRFvC8PA7/SHeW2L4UsJCK4d7ViBJQmuEtbwa5gDVAqYIjrl/nwHZbx3CsWoQQMV8utRD2SjjJA77A+vmTpwdr9MeOQSqGmpSslDG2QXHzoIYEnvGJZq3IHy0jgkwp7Mkj7gPebn99cLPA0Bay9xziWtmjcixTlgucQv0ZVPBTxgNuX+d19wnvIlURrE61h0vHFlfpGGcmCdK4NRu/9IxaHk6t72qL0hl8WPtOOapffEVNFSoyQhM1lyt+hT98STPM1kYHS3GMtu7/P+rFCJ6Dd94tdKByfx3xDx7wasl5kufqvbj+KcNbd/LHiAUA6d+GmXGb3GqV/FmnpQgqojZQsAHuHkkMWIHeUc5pHi4kQNTwnroLEjss6OktN0a4sGGJwYbphLNKtWHfLw6NiKD629TcWKVBA2SuuXv53d3klFdWra3u4T2sJKt7lMRhRYbjiS5gX0A7jcwsCJd8zDHRNtKG7oNUoJfk2KAcUpKAMNBE=
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM5PR10MB1419.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(346002)(396003)(39860400002)(366004)(451199018)(66446008)(66476007)(7416002)(66556008)(5660300002)(64756008)(71200400001)(76116006)(66946007)(8676002)(316002)(6486002)(54906003)(4326008)(86362001)(478600001)(38070700005)(6916009)(33656002)(2906002)(122000001)(38100700002)(8936002)(6512007)(41300700001)(6506007)(53546011)(186003)(2616005)(36756003)(44832011)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?eG8zNUhrbWdvYzVJZTgvOFRtZTQxMHA0clo2MHpTa3hBaDlwM09BTkpWTjdD?=
 =?utf-8?B?Y0tBWENCdTZrVzJZY0kyTzZwSGJMZDdqYkg4eTMyT3dobVpNZ00vbHVsSHNM?=
 =?utf-8?B?V3BER0o4OEhydit5ZTBPdnZSSVNvRGhvbFZEQmx4OG9OZW9wMStBTEl2Z2Rv?=
 =?utf-8?B?VTE2RDJZUUpNWkhRbFE0ZGh2dkJtYi9wNmlCYVcwQ1pjWXBVT0w5bjJSV2R6?=
 =?utf-8?B?UWFYbEJDaXpmL3VkamRFaHo2VGRUcmJsRlI0MWRtWFhTV05IZG1WeFdnYk1j?=
 =?utf-8?B?NEpMSS9ENEwrclBYdVgxVFZnZ0VhVjg4V2VnNnN1UXZzOXJWK2ljWEpZTk5w?=
 =?utf-8?B?R3VZQzJkVHpqWGhadnRwNWZwQnQwMm5ES2hiMTN6U2lTanVPd3FycyttTUg1?=
 =?utf-8?B?TG5uUHRaLzBITXhWcW13M1BFcllTdWx6K0liVkdvRDFQZzYzTzRlN3Vldml1?=
 =?utf-8?B?NC8rK1VVYit1ZVhzaElnQUNSV3prUWxYUDdpU2dwa3I5N3BjVG41N3Ftd0RD?=
 =?utf-8?B?bnpWcXdadGNNVmRONEV2dTFXajZYMXRISWxoeXNhVHRRY3o4My9nU1VOU3d6?=
 =?utf-8?B?NEEwdE9PR2UxSEQzY2M4dUdtTkMyTUt5RFE0YlRENzU5ck9EdEhEcUpPU2x4?=
 =?utf-8?B?L1FVNzJjaHoyT0ZtOHhZVDZEWjMwbXFrazFsNVFEa1I1QWdlOU4wdmxkYWhk?=
 =?utf-8?B?OFBvbTZ5ejcxYVRNeUZkNU9CZFRUWEIrMjBFUHpoV0J1L0pkWmFMbXMvdHMx?=
 =?utf-8?B?ZlBzSVdodmVFY1pPMnU5NHpQTWRrb1VzbFFDOXZEZnN3d3o0RlIrYWZZbGNr?=
 =?utf-8?B?RlNyWWhvaEZGOU80NFJLdW80Y0YyUTlsb08waTd4eUhLR1JWNUpwdkx2dTZq?=
 =?utf-8?B?aGJOaDBEY3A5WFVBWURPNWQ2S3lSMHpjTU5jZ3lSV2tKRE5hZDNTZk9USk12?=
 =?utf-8?B?RTFucStHRk5mNS90dzNlYVZtc1E1d2cvUFcvaXdjdmZRUmRtZ0R5aFFTNk1Q?=
 =?utf-8?B?aUh4enQ3Rzl1amJNOGFaRlU1MG4xU1ZQeDdOL2R6QTN6ejIvNWllOE1hcGk2?=
 =?utf-8?B?TkpuM3NPUDBMdm00Mlppck54L2pXWFBxemVmMHZIVkZHSXUwYURaTElqcllN?=
 =?utf-8?B?VE5kVElHQmh0U3B6UEQwM0Z5WmU0UjVlVVZvUEpQcllEenB3YjQyVU11MnBr?=
 =?utf-8?B?R05hSkRZY0VUbUJ3enloWjd6SHZJQW5LeWMzb0VaRnM5cTIwY2dMZytvZ25Y?=
 =?utf-8?B?amUvRFZZTmRKQ1o2S0lSZ21ZMkd3ZVhwTEE2bUhTMTVoMSt4dXZPNHFXdVZD?=
 =?utf-8?B?Z0dXNklxSHRoYkdocHprS0dmcFpZNzRSQW1FNk5sYm5YV2EzaFR0QU9SeGQz?=
 =?utf-8?B?dnd1Z1JrcVpNMHA5WGxOakQzMEhXMlFtZlZhdXllcFRVWXdKcHJGdnBUMXBt?=
 =?utf-8?B?NXJpQTJKRW9LUTNkZ0tMRTVHYi9vY0lGQkNsdm9FaU8yVVYrVURtVFBaSTJD?=
 =?utf-8?B?NG1HZWpTMU5KMmM5K0R0bW1xSjJOU1FYcVBPZ1BLNnNlTStaRVlTK2FnNFpK?=
 =?utf-8?B?ZW5OZGhZR2pVRWVaWVQrZ2NlM0FEYmhoUktVQS9taU5zSFJQY1VUeTRSd1lm?=
 =?utf-8?B?WFo4UTlHUGpxT3dlVmh0TVBja3VneWsycDd0b3RXeWRNMXVZQUoxZUxVU2Ez?=
 =?utf-8?B?UlNMY3JlK29FbkQ2aUJ3RG9jc0xQMHlWSmNEcDF1L2lhVHo0SGRaOExiQXc3?=
 =?utf-8?B?dkpkdWRiS05ML21jYm93VkpJZFdIdDlQd216RSs1Znc2T3BQeXgvaHg1dWpB?=
 =?utf-8?B?Qk1UeDQvbDYwUytiQThnZkR3V3RJZy82UGNoVDJBdy9lb1Q0Wml5Z3dCS0Rm?=
 =?utf-8?B?QmFyeCs3Y0RGZEhVU2Q0dWZka3JYTi8zSkt4aDlNb2pXN2RETUFnRUJqTi9v?=
 =?utf-8?B?VUhkS3oxMms5Wk1ySGd0a0NWN0lEaWJCeG91TzdsZ2oxLzdKQ1RHdkdFY1ZV?=
 =?utf-8?B?OUZaMXFqZm93UzZlVWs0SjBHVDBYcDFxcDhUbStIQ3RzQVIzSTRVbE1wckgx?=
 =?utf-8?B?dDh2Z1I2NERsVDQ4dkl0aUZIOFl4QkpqRSs3SmlWYmJ0dEloYWdhQ0g5WUVG?=
 =?utf-8?B?RkZpdWh3UEdKTEphZlhRS0M3cjFQNWZGZHBHWlk4Q1lHOXdRb3pZblovQ0Fk?=
 =?utf-8?B?VWJNWCtJY05LdFU2NkJHSVNaNzR2S1VRTXc2RDEwd0NZTmwrbDAxY2FXSkpv?=
 =?utf-8?B?NkZKRzVnZ3NERmNNRnBqNU1DKzVBPT0=?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <72B7FDCBDD09804FB598268D21ADB73C@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?QXlOczZ3djd0ZllpQUVWbGtaWk01QzJtbmF1QXJENWs5RzBKaTJwTjI2TTNz?=
 =?utf-8?B?Rmd6eExLQmJvNGVySzYzRGZPT0tvbmxQUDFicWFFT2pxQWk4T1k4Yi9GQ09o?=
 =?utf-8?B?Zmw5Y01HS1ltS29FdC9ucDFQbmwxOThkb1hTSWRwV25rRVZxQVV4TUw2dnNI?=
 =?utf-8?B?ZWZPb1dmWVZHbjZRK2p5ekpWNjRtei9YM1gva2JwMUcxZkpQSHpZVGU1aWcz?=
 =?utf-8?B?WHFvanVwcE1MWVM5RmEzMW5tRTNya0c0cllRU2N4azdpbzdsRHExMXBSQzRQ?=
 =?utf-8?B?L1ZjSE9kK1d0U05BZ2NjT1BYc2lVS3daSFA0MGlSZWJqNFRLL3VFRURFdzUw?=
 =?utf-8?B?bDNrRlhmUHNNYzg5RTNRdUZsbGRodUVjL1dzM2dvK09VNmlWWWk1ZktCU0tC?=
 =?utf-8?B?NjhmOXAxUUZlNzhtNi84RGpLSUpWQ0RDT0lDaThncGxGekxMVTFtbGZmTU5s?=
 =?utf-8?B?Mit4SHdmeFoyRVpHZ2wzV29EeHdTdFNKVU1tM1JTbG43ZDEzWDQ0STNnZWZh?=
 =?utf-8?B?ZC9rYloraU5teFlRNW4vb1R6UmVQRVBNV0tuZkxVOVBaTGtDdW50eG4zQTAw?=
 =?utf-8?B?NDg2bTQ5R1JqbDNWTmRsMGRuMUg3d09ucVhRUUhObU9BQXVIRzNjMlVmMm5B?=
 =?utf-8?B?NjZmQzdjbFBkUFlBaitqam4rRnVUeGY5b0o4ejJaOXBGbGFZY3VQVzlLQVZ1?=
 =?utf-8?B?NWdPeWFGZlRKak12ME1kS3cyMzNFSzRTaGtWL1M3TUZtSDEzWFBRdGxacVhR?=
 =?utf-8?B?QmVlUThaeE45WWpudjhPTEQySkxYeGFvMEY3WUVZR3hISHQzTm9sMjhldjd4?=
 =?utf-8?B?Rmx5T0dnRjVrMnZLbUFXRjZpS2JNUHVLTGNRWElzS2k3QkxlczY0VWpIR1JG?=
 =?utf-8?B?eEJoYnJwVW1NOWxubGZHTlNMazRpeU0xNVphWkFpeHljZFpCOWVTb0FhQzl2?=
 =?utf-8?B?VG1jck5wcy9OYVBFRkV6c2d2QTF0OVVYaE83dVFGVVJnRlJBNjVqMERzc0ps?=
 =?utf-8?B?YnFRcWlUWWpMLzNoOHRUdFMrSEo3dlJNT2o4S1paKzdKMllQUUZBWlh6eFFN?=
 =?utf-8?B?c3Ayd1R4T3lRWmdCcEN3b255OExPdUl0TjBxQUloam03Q09SZktNcGdsbFJj?=
 =?utf-8?B?RVZoTm4yZUYzUnRPSDloZHkwaVZnSWdWY2tZQXY0THZhSEJQWFBNdmlMVE85?=
 =?utf-8?B?dEZ2QTRlUE0vclB1N2E2aHdiTE90ZmwyTjRzOFNyRUQyMEYwNXZINlYrdDdP?=
 =?utf-8?Q?/P9Eq+H2l8pbqBh?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM5PR10MB1419.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: f19a9ca1-6d93-45a9-dc3a-08db270467b8
X-MS-Exchange-CrossTenant-originalarrivaltime: 17 Mar 2023 16:26:47.6421
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: EXrnrJuojFc9h7Vhh9T+Qx+O3YLxsovQpn1nssEsQehqpu2P22/ky+aRUO+1us2QunxUq9IXopZwc08FGfPDR71MGZ2W5zpSADsQCzcLE4k=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA1PR10MB6616
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-17_10,2023-03-16_02,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 adultscore=0 phishscore=0
 mlxscore=0 malwarescore=0 mlxlogscore=999 spamscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303150002
 definitions=main-2303170110
X-Proofpoint-GUID: sM7hL4XuLv9fMx-Bfy34yGvQXtNkDniB
X-Proofpoint-ORIG-GUID: sM7hL4XuLv9fMx-Bfy34yGvQXtNkDniB
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

SGkgUGFua2FqLA0KDQpTZWUgdGhlIG91dHB1dCBiZWxvdy4NCg0KPiBPbiBNYXIgMTcsIDIwMjMs
IGF0IDQ6MTAgQU0sIFBhbmthaiBSYWdoYXYgPHAucmFnaGF2QHNhbXN1bmcuY29tPiB3cm90ZToN
Cj4gDQo+IEhpIFNhZWVkLA0KPiBPbiBUaHUsIE1hciAxNiwgMjAyMyBhdCAwOTozMTozOFBNICsw
MDAwLCBTYWVlZCBNaXJ6YW1vaGFtbWFkaSB3cm90ZToNCj4+IGV1aTY0IHZhbHVlcyBhcmUgbm90
IHVuaXF1ZS4gSGVyZSBpcyBhbiBleGFtcGxlOg0KPj4gbmFtZXNwYWNlMQ0KPj4gbmd1aWQgICA6
IDM2NTU0NjMwNTI5MDAwNzEwMDI1Mzg0NTAwMDAwMDAxDQo+PiBldWk2NCAgIDogMDAyNTM4MTkx
MTAwMTA0YQ0KPj4gbmFtZXNwYWNlMg0KPj4gbmd1aWQgICA6IDM2NTU0NjMwNTI5MDAwNzEwMDI1
Mzg0NTAwMDAwMDAyDQo+PiBldWk2NCAgIDogMDAyNTM4MTkxMTAwMTA0YQ0KPj4gbmFtZXNwYWNl
Mw0KPj4gbmd1aWQgICA6IDM2NTU0NjMwNTI5MDAwNzEwMDI1Mzg0NTAwMDAwMDAzDQo+PiBldWk2
NCAgIDogMDAyNTM4MTkxMTAwMTA0YQ0KPj4gbmFtZXNwYWNlNA0KPj4gbmd1aWQgICA6IDM2NTU0
NjMwNTI5MDAwNzEwMDI1Mzg0NTAwMDAwMDA0DQo+PiBldWk2NCAgIDogMDAyNTM4MTkxMTAwMTA0
YQ0KPj4gDQo+PiBJIGhhdmVu4oCZdCB5ZXQgY29udGFjdGVkIFNhbXN1bmcuIERvIHlvdSByZWNv
bW1lbmQgYW55IG9uZSB0byByZWFjaCBvdXQgdG8/DQo+IA0KPiBJIGFtIGFibGUgdG8gcmVwcm9k
dWNlIHRoaXMgZXJyb3Igd2l0aCBhIFBNMTczWC4NCj4gDQo+IG52bWUgaWQtbnM6DQo+IHJvb3RA
bWlzc2luZ25vOn4jIG52bWUgaWQtbnMgLW4gMSAvZGV2L252bWUxIHwgZ3JlcCBldWk2NA0KPiBl
dWk2NCAgIDogMDAyNTM4OTEwMTAwMDViMw0KPiByb290QG1pc3Npbmdubzp+IyBudm1lIGlkLW5z
IC1uIDIgL2Rldi9udm1lMSB8IGdyZXAgZXVpNjQNCj4gZXVpNjQgICA6IDAwMjUzODkxMDEwMDA1
YjMNCj4gcm9vdEBtaXNzaW5nbm86fiMgbnZtZSBpZC1ucyAtbiAzIC9kZXYvbnZtZTEgfCBncmVw
IGV1aTY0DQo+IGV1aTY0ICAgOiAwMDI1Mzg5MTAxMDAwNWIzDQo+IA0KPiBkbWVzZzoNCj4gWzE3
NDY5MC4zMDU1MDddIG52bWUgbnZtZTE6IGlkZW50aWZpZXJzIGNoYW5nZWQgZm9yIG5zaWQgMQ0K
PiBbMTc0ODc4LjQ4MTAwMl0gbnZtZSBudm1lMTogcmVzY2FubmluZyBuYW1lc3BhY2VzLg0KPiBb
MTc0ODc4LjUzNTk4MV0gbnZtZSBudm1lMTogZHVwbGljYXRlIElEcyBpbiBzdWJzeXN0ZW0gZm9y
IG5zaWQgMg0KPiBbMTc0ODc4LjU5OTk4Ml0gbnZtZSBudm1lMTogZHVwbGljYXRlIElEcyBpbiBz
dWJzeXN0ZW0gZm9yIG5zaWQgMg0KPiBbMTc0ODgzLjY3MzAwMV0gbnZtZSBudm1lMTogcmVzY2Fu
bmluZyBuYW1lc3BhY2VzLg0KPiBbMTc0ODgzLjc0MDA0NV0gbnZtZSBudm1lMTogZHVwbGljYXRl
IElEcyBpbiBzdWJzeXN0ZW0gZm9yIG5zaWQgMg0KPiBbMTc0ODgzLjc4NDAyNV0gbnZtZSBudm1l
MTogZHVwbGljYXRlIElEcyBpbiBzdWJzeXN0ZW0gZm9yIG5zaWQgMw0KPiBbMTc0ODgzLjg1MjAz
NF0gbnZtZSBudm1lMTogZHVwbGljYXRlIElEcyBpbiBzdWJzeXN0ZW0gZm9yIG5zaWQgMg0KPiBb
MTc0ODgzLjg5MjA0MF0gbnZtZSBudm1lMTogZHVwbGljYXRlIElEcyBpbiBzdWJzeXN0ZW0gZm9y
IG5zaWQgMw0KPiANCj4gSSB3aWxsIHJlcG9ydCB0aGlzIHRvIG91ciBmaXJtd2FyZSB0ZWFtLiBN
ZWFud2hpbGUsIENvdWxkIHlvdSBwYXN0ZSB5b3VyDQo+IG91dHB1dCBpZC1jdHJsIG91dHB1dCBo
ZXJlPyBJIGFtIGludGVyZXN0ZWQgaW4gdGhlIGZ3IHZlcnNpb24geW91IGFyZSB1c2luZy4NCg0K
TlZNRSBJZGVudGlmeSBDb250cm9sbGVyOg0KdmlkICAgICAgIDogMHgxNDRkDQpzc3ZpZCAgICAg
OiAweDEwOGUNCnNuICAgICAgICA6IFM2NFZORTBSNjAyMjcxDQptbiAgICAgICAgOiBTQU1TVU5H
IE1aV0xSM1Q4SEJMUy0wMEFVMw0KZnIgICAgICAgIDogTVBLOTRSNVENCnJhYiAgICAgICA6IDgN
CmllZWUgICAgICA6IDAwMjUzOA0KY21pYyAgICAgIDogMHgzDQptZHRzICAgICAgOiA4DQpjbnRs
aWQgICAgOiAweDQxDQp2ZXIgICAgICAgOiAweDEwMzAwDQpydGQzciAgICAgOiAweGU0ZTFjMA0K
cnRkM2UgICAgIDogMHg5ODk2ODANCm9hZXMgICAgICA6IDB4MzAwDQpjdHJhdHQgICAgOiAwDQpy
cmxzICAgICAgOiAwDQpjbnRybHR5cGUgOiAwDQpmZ3VpZCAgICAgOg0KY3JkdDEgICAgIDogMA0K
Y3JkdDIgICAgIDogMA0KY3JkdDMgICAgIDogMA0KbnZtc3IgICAgIDogMQ0KdndjaSAgICAgIDog
MjU1DQptZWMgICAgICAgOiAzDQpvYWNzICAgICAgOiAweDVmDQphY2wgICAgICAgOiAxMjcNCmFl
cmwgICAgICA6IDE1DQpmcm13ICAgICAgOiAweDE3DQpscGEgICAgICAgOiAweGUNCmVscGUgICAg
ICA6IDI1NQ0KbnBzcyAgICAgIDogMA0KYXZzY2MgICAgIDogMHgxDQphcHN0YSAgICAgOiAwDQp3
Y3RlbXAgICAgOiAzNDUNCmNjdGVtcCAgICA6IDM1OA0KbXRmYSAgICAgIDogMTMwDQpobXByZSAg
ICAgOiAwDQpobW1pbiAgICAgOiAwDQp0bnZtY2FwICAgOiAzODQwNzU1OTgyMzM2DQp1bnZtY2Fw
ICAgOiAzOTg5OTM4MTc2DQpycG1icyAgICAgOiAwDQplZHN0dCAgICAgOiAyDQpkc3RvICAgICAg
OiAxDQpmd3VnICAgICAgOiAyNTUNCmthcyAgICAgICA6IDANCmhjdG1hICAgICA6IDANCm1udG10
ICAgICA6IDANCm14dG10ICAgICA6IDANCnNhbmljYXAgICA6IDB4Mw0KaG1taW5kcyAgIDogMA0K
aG1tYXhkICAgIDogMA0KbnNldGlkbWF4IDogMA0KZW5kZ2lkbWF4IDogMA0KYW5hdHQgICAgIDog
MA0KYW5hY2FwICAgIDogMA0KYW5hZ3JwbWF4IDogMA0KbmFuYWdycGlkIDogMA0KcGVscyAgICAg
IDogMA0KZG9tYWluaWQgIDogMA0KbWVnY2FwICAgIDogMA0Kc3FlcyAgICAgIDogMHg2Ng0KY3Fl
cyAgICAgIDogMHg0NA0KbWF4Y21kICAgIDogMA0Kbm4gICAgICAgIDogMzINCm9uY3MgICAgICA6
IDB4N2YNCmZ1c2VzICAgICA6IDANCmZuYSAgICAgICA6IDB4NA0KdndjICAgICAgIDogMA0KYXd1
biAgICAgIDogNjU1MzUNCmF3dXBmICAgICA6IDANCmljc3ZzY2MgICAgIDogMQ0KbndwYyAgICAg
IDogMA0KYWN3dSAgICAgIDogMA0Kb2NmcyAgICAgIDogMA0Kc2dscyAgICAgIDogMHhmMDAwMg0K
bW5hbiAgICAgIDogMA0KbWF4ZG5hICAgIDogMA0KbWF4Y25hICAgIDogMA0Kc3VibnFuICAgIDog
bnFuLjE5OTQtMTEuY29tLnNhbXN1bmc6bnZtZTpQTTE3MzM6Mi41LWluY2g6UzY0Vk5FMFI2MDIy
NzENCmlvY2NzeiAgICA6IDANCmlvcmNzeiAgICA6IDANCmljZG9mZiAgICA6IDANCmZjYXR0ICAg
ICA6IDANCm1zZGJkICAgICA6IDANCm9mY3MgICAgICA6IDANCnBzICAgIDAgOiBtcDoyNS4wMFcg
b3BlcmF0aW9uYWwgZW5sYXQ6MTgwIGV4bGF0OjE4MCBycnQ6MCBycmw6MA0KICAgICAgICAgIHJ3
dDowIHJ3bDowIGlkbGVfcG93ZXI6Ny4wMFcgYWN0aXZlX3Bvd2VyOjIwLjAwVw0KDQpUaGFua3Ms
DQpTYWVlZA0KDQo+IA0KPiAtLQ0KPiBQYW5rYWoNCg0K
