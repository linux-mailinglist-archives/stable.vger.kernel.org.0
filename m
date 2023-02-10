Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D56CF692822
	for <lists+stable@lfdr.de>; Fri, 10 Feb 2023 21:22:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233757AbjBJUWE (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Feb 2023 15:22:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233797AbjBJUV3 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Feb 2023 15:21:29 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 090B7812B9;
        Fri, 10 Feb 2023 12:20:47 -0800 (PST)
Received: from pps.filterd (m0246632.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 31AHwgiU019292;
        Fri, 10 Feb 2023 20:20:02 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=G7itgFEa3EaP4RAlj/7ppv8fNIqzjvJEuHWT2zIn++o6ycnap4SCCcGmn9bPfI5OCZy+
 pjUb/8o3I+NtUsSrQPLsm7TVcq6aGkQDO60j6jXi/ujmo0SWOVQDTFquYrJ0rEpYf2zm
 vdlbToyiiOShLfMzCP31/+/QFgl6KS/+Uh0Zgllbk6ExmFd/C0IayX1FrGYCqdYTBufV
 6DBrcR/pssPLbPMqeY4yJE4ody4nZr74Xz5rNo8bsSTUvl5HPxqSGwHo3/dZU/APi5M2
 iQoBqYlIwuLeUx2gXeZkw9Edkc30vsoq6fox+J7wxxqKG68fWwkIh1NBr/iIpnFSBoZ0 Gw== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nheyu68kb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:02 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 31AJAb6M036229;
        Fri, 10 Feb 2023 20:20:01 GMT
Received: from nam04-bn8-obe.outbound.protection.outlook.com (mail-bn8nam04lp2042.outbound.protection.outlook.com [104.47.74.42])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3nhdth2c96-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 10 Feb 2023 20:20:01 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=S3K3DzJiqLYidI7dp5+J6h0TpN4HOcH/Tdz52/xbk8fQJvC2odrn1Y+oYwITOMkjOImn37QAZ36DPtZIckodLpkQGw0MyQikxWkv2dcODKj9cQ4pAoIvLd0c3A3Y/GSyc6VucxaJmFMx0XHzd44SP91VDTwaKc2rS3LaFgCtf7QNHOZ9hkLSDIkXKDz7Hz6t1M+OXtza6A45YAAMF37+I8WpGC9mQdijkEwMSQ75YpNlNCtecEdOZbZMve/DOVuggqt+/Z4agzkTk1KFx8p5fGSfxlJ8tSYdELLDwDo8NeSiqkFsDAFT9gwDyHWvK6NWK+/gtHvVS5JKpHOYmqY2Pw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=j3XpOeXuGQjSiHUifHg+1HrtQlPfNGKiAb72oLHd3h/LYTbpi1BZCC3h9/goKOJFBvEJ56vqRs8ZdlAdATZ3Or7vUWN6WjDV8PNlBMhe3HZhqd7g8Bbxgu9oEBu7RmN4ltGzZDjqb2LellNBN4cwdbR5imrD/t8o/WzLJ0V0wrOT5NOPVjFDZ62n0pcv7P4Cm6RYNhwpER7UyFN1ANmcsWfg+/PxYRgqVxcfPEJ/rH1SPn8Ia+MA2+njQk8Ui5exebZey8PYKTsOIWLakJ+WdB64DdraE0z6CS0cGFpLZemZ5wPUY19pIDFozbxnpr01N9GzuXcBRdAGNS5i+JuPVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=VL5ggjV7l8uquv3Cdfin43ZELlq/Zxr4naWQDZOYm1Y=;
 b=ZOHu0xjbAaIi37BcQ/qYuf7kng+gE9bLoWtbgaU7H064NGVRFyB1o6ZdsW8KggDebMBWn9v1NIJNyR0cw1LqWPB31+Rv19ZTrh4TOlbIvGIjJZfc6Kdw0HWCtojEjtXYd+lfnh4Vr++YtpOzJQGnGhXxUoF+kU7udvKAyS1FxVY=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by CO6PR10MB5652.namprd10.prod.outlook.com (2603:10b6:303:135::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6086.19; Fri, 10 Feb
 2023 20:19:59 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6111.006; Fri, 10 Feb 2023
 20:19:59 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-riscv@lists.infradead.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, linux-sh@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>,
        Yoshinori Sato <ysato@users.sourceforge.jp>
Subject: [PATCH 5.10 v2 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Fri, 10 Feb 2023 13:19:39 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v2-5-ada7b8d36096@oracle.com>
X-Mailer: git-send-email 2.39.1
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v2-0-ada7b8d36096@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SJ0PR03CA0215.namprd03.prod.outlook.com
 (2603:10b6:a03:39f::10) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|CO6PR10MB5652:EE_
X-MS-Office365-Filtering-Correlation-Id: 7574f9b1-dfb4-4c88-7b4f-08db0ba42eaa
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: S/Ja0UrE7IhB9EsREiMHj6WZoxJfc+JBtw9zmJ55Xyfy2Ybs1F8jJAXWfiLljK3S0EhJhTW+cBU4RrQc+zlasEtFwTiZLdNL20iTFco3fSrDEYk9nEAqbx6ElBXvUvi3HhwTUJAp/epF5RTNdtY0UAg6ArYyNJ3nT/9jZNrqHDiofQUnZ/Sh8/IxhhhrC8ozJxXRS9BLS3ORx8ZeKpPWIV2WeAmnUjzXUjC8jYJ/rLCe6KyOIIZUImfWdHBeFUbVEPNZ8QFXoqifPR5jiyoF98/ZYgM+Sjokp5PdSVLtoCxCQXf8vZjvSct60ArV8GDfPxyby5ORdAt6+At78QdttdVJeYS91enzROzifJa8Q7xtYLtOiCAIUr/dckwM8Y0K4Eq0EiNasl/4BJ8trs3Nr9a9EmH45C7dhP/S8JXprZld6N0uStxDmcx2IuXkB0AObKe6SdxJvozVm7JxBc7Pcm02t1jMTbjSVgVTEUuYBKZemL9/CsiFWMltn17nFPuwPjkRsYxrfnuWfy80v+brCrH6s+6SM7b0Y90P0900Cwy+ubTS8fxojMJWgGKyXxIdpbtttDoAZXoTDEt3vueYsGSi00Mbrf1iIkseW9/5lZLYg6X42Fh2Lkt5XqYCMjavTKuHWRuz5P4Mz2Vjvl2864XF4LYfn7ykRJZiYkoGu8AsyiHKvVXESb+HYS7VbWBAlzWSTCqVoAHSg99Oi9hlcQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(376002)(136003)(396003)(346002)(366004)(39860400002)(451199018)(2906002)(36756003)(966005)(6666004)(6486002)(478600001)(6512007)(86362001)(2616005)(4326008)(6506007)(6916009)(8676002)(66556008)(66946007)(66476007)(7416002)(44832011)(186003)(5660300002)(316002)(38100700002)(8936002)(41300700001)(54906003)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?ejhlRE5HK0oxdngzeDQwbzZwdDc0VWVIYklTb2U2eDlHaGRUUWw1OHF5L2dF?=
 =?utf-8?B?blk2TWxCanJyL3QwQUpDTkFyL2IrVGpUam9UcHdEV2NwejAzdFFlTGpEdjk1?=
 =?utf-8?B?R004T093Z0V6dVd5VkNMS1VzVlMyaFZuUkJ5Uys2ZkRzd21tcVk4aC93MHl3?=
 =?utf-8?B?T1gwYnRjNTRHb1VOTTJuL2hVTkFKOFExNG9GbWM3YjlNNkRtamxSR004c2tr?=
 =?utf-8?B?UlhTeExtYVF4dlE4ZXkwbDN0S0ppZ3hNdkFSV0ovV3FPUXpjc095ckJ2cEN5?=
 =?utf-8?B?Y0phT0pudTdYbnpESFU5YVFOV2VaWkduZ051aGxZL1J3V2JXd0tIRHhTMnJK?=
 =?utf-8?B?ZWZmMlEvSXJPSzA4QTJ3ZEdZemJ4SE5XOVZFU25ELy92YUpJcGlHUVVUb3Jq?=
 =?utf-8?B?dmE1djBWV0ZldTVKZmxUTHZ1WDVSUndCT0pxRmVFWE9KL1RyY1hOSXJCbERy?=
 =?utf-8?B?YXAzbnRaMmpJNWwvNlVuWS9na2k2NTZ1Z0ZlT2dFUnNhUTF4aWdYKzlzajFi?=
 =?utf-8?B?cnhRRWFDZkhRaVVnN0psODN1cUw4VVI4dng5YkFqeEJKVi90aFF4c1dWVHJI?=
 =?utf-8?B?bnFqcnlUMFBOOHlzNFh5Tm5rMW9sM3pNUVA3UVRiUkpmSTVWU1ZvL08ycG1T?=
 =?utf-8?B?clZHYlp5ZlJVNFAxK2ZaaW9taEpHcFFmWVU5R0hZZHk5Q3FnY1NPVThUaktk?=
 =?utf-8?B?bHlIYzI4dVhMNDBkU0VrS3FaRkdVbXg5Sm9XT0JqQm83RXpnY3NSSzNTZWcz?=
 =?utf-8?B?SkZUVzFzVTgraGx6RklqYS9VR09BQ1IrK1krQzFEKzdzZFRWVEkrWitCaWpI?=
 =?utf-8?B?UWROcFovTHlhTmxvN1VpeXRhVldNb3czdk40RTVoYTZoRmVmTi92bS93ZEVU?=
 =?utf-8?B?aGlybW1YNnZFVXp4TjQxL1QzM1d4b2x1blJEM2xvZlhiOXJldUFnMVloTGM0?=
 =?utf-8?B?YXRzWUdhdnlEeEVnT0JDeDBpSitVTEp3NjlOeWVXYXNDK09KVHNSVDQrcnZC?=
 =?utf-8?B?d28zL1hmWWN6OUE1cDZNdGExYUd3NUJzNlUrWVJOeHpZYU1XbXBkbnJJSjNz?=
 =?utf-8?B?bkx2QXk0NVJNUDR3SzBNcTZiSlp4T0hoR2lETzNzNnJ1djhvTms4S2p0NFVM?=
 =?utf-8?B?V05FclpsRERmNFlyeERTTHdDaEtUSVRzVENhNEFVYkVsQnVxWjZEdmhyQTFV?=
 =?utf-8?B?UjJNU295WTAxUXNEbDJBV0R0Q0pZL0RiWFYxR0VyZ24rNys5REhpSjYwbFR2?=
 =?utf-8?B?MFBsWFRvS3RabGlZdDk4ZmQ2bitIdGE4SVZZT2ZCaEFabDRudXJ5dEVQZjRy?=
 =?utf-8?B?bmxsZkhYT0hSY1l4NGhzSmxJQTJSZWFrUFFQeUJhZWVpcWNzWmFSR0xmZHFU?=
 =?utf-8?B?d3Y5aVNpd05MbTdDR04zc2lLV0FVL1hZVXU1aUg0YWRCUk9yZmpZL1Q5YkRu?=
 =?utf-8?B?UXRhZmVNVmI0STFTeXpBZHVIK0xPb0hSOHJwZ250by9Gbkh0bjNEOGZ5Y29P?=
 =?utf-8?B?SFhHcTNzWHduUnkwRjhqQ043bmk5TVYxTnhXV3JlMnRvSFZWUWxWTUtjS1Q0?=
 =?utf-8?B?dXk5VURBSW1kdExQVFpFbmNhWjJuNXFOSlNXODNZUkQ4STFud3pybHlLclMr?=
 =?utf-8?B?T2FEeWt0VDFwT293Q2ZYZjZnMFlrOU0vbE1wcGZVY2lpS042cEZQZXJMaDJn?=
 =?utf-8?B?OHpBK2tZWHRxemVkMk1WM1lLOUQ1TXNxRHBVdlAwTUtESE5zL2NtRjBiYVRr?=
 =?utf-8?B?dWtJRXlPcXhXQUhyNWo2bXpYdmRZalNtMjYxVzF3Q2RsRjFRNVJyTEdDMStR?=
 =?utf-8?B?UnVoU3JLUEdKNHFKWnZ6OUVMMHRMb25iRlVITndhNU9tQnVxanNrYW1aSUVX?=
 =?utf-8?B?WEdjckFaWTRWS0UxRnpDT3lqYmJydXorVFNUa2NGbDBEUDBUQzJZeVdtVkpK?=
 =?utf-8?B?SnJET0Fhd0gwRkFCQm15Tk9aVVVkQm51MUZuNjZObUVld3AzWlBIK3hYcmhq?=
 =?utf-8?B?c3pyZDRTRDRoNFcyMzhkYlRwektFQzhYSmloQUpnam4yK01CL2I5cklPdU1J?=
 =?utf-8?B?cWxjblhSVmZJdWYxa3FHZlpWakwzYVVGcEY2bHN0ZGJnV1VubjJBWkMrRGdM?=
 =?utf-8?B?c0VidEJORDBuS3QvaWZISDdtSTlFVk90eU9jclR5c0d3Ky9RWTlvYWVDZUpT?=
 =?utf-8?Q?QblZk/LEXZtocZKndS1B5k0=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?akxRbDU5MWVGNzlYTkNzbmtuaGtSbGRDeStFelJZa3lIR3NPbW9UUjErYVI1?=
 =?utf-8?B?WTZBd3dNck5rNVk4NXhFeFJwQlZvZEc1SVhicjhyOWVpQU5OK1l6Ym1WcEVr?=
 =?utf-8?B?dmh0Mi9CcFNVZjVFV2wreHhtbmxpWDVSbUZqYWRmN1lxTFVNRnBJMDJDUHlh?=
 =?utf-8?B?STh3VlAxNGM1blpYcGdPVjFPejE4MmI3SHRWUk82ZnVkL2ZiRTNtVGVFZVA5?=
 =?utf-8?B?ZUJIY0d3TUhFaWNXR21BcWpSQTdteXl6TmQ5eVpjSEVqQzI4UlFyUmFVbm5y?=
 =?utf-8?B?WjZaY2tHTjFJUEc4Tk9QMHJoVmFBd0pYc0p0ZWhNOHNkaHl6cDhLM21tMlA3?=
 =?utf-8?B?V2ZmTkVyYis0V2prM3o3eDV4TTVLbUlFVUk2UHkwVXVlRS9YTFZQT01pQzlL?=
 =?utf-8?B?bEdKTnhMb3RMT3VzOVdaZVU3SmRtOUFEMzF3QlFXUmZtTHd3YmdSZHZab2hz?=
 =?utf-8?B?TUIzQ3lMSE11ZVU5ZDZYcmhWeVZ4MUR5R2pvc3IwSWttTHhlV2k5by9rb0Vj?=
 =?utf-8?B?c3h1a0hpTVdqWG00bHh3WGRnUDJjQ2xuM2tlS1VSSnFHYUlrOEdUWmduTTk4?=
 =?utf-8?B?V1lNOHMxdkNReWdGTGU2YkQ4SnNOZWxuNFgxaU1ZbVBPaVN6MmRqWUIzT09Y?=
 =?utf-8?B?TWtvWFIrT2FIaElMY2VnZHgvRy9CZ0dMNlJpdWdQZzg0U250UjIzRXcraExN?=
 =?utf-8?B?dTUweFE3QUNSYWFlb2NuSTJOTFF5VEpqbFQrOUF3WFlXNFA4QmZGWFV3Ry9S?=
 =?utf-8?B?L0xnTU9aTzcxU0IyeW9DV2laeE55QzRtK3N0b2pjZVl0U0dmck1HR2VwY1Fu?=
 =?utf-8?B?R0RKZERsK3JFQUZTcjZtNUlCcnB3anJoSjd1NWs4djd6VXdEU3Zhc2N1WGRx?=
 =?utf-8?B?SzdNSEZzZ1hWTGJsRmxUV1dqN3NsQWRzRzBGWWtWOGdpZXJmcFNhSEl4eWh4?=
 =?utf-8?B?YkROZEJKdzZEWHk0Sk53L2VhYzJoQkxCZEdiTmFlVFZTRi9tNlYyWmJTcita?=
 =?utf-8?B?Sy84cEN4WUpKYis1YXo2VGpkbjFzcGw2MytVQlBhdG9JV00reTFKcS93dnZZ?=
 =?utf-8?B?dk1KWndxYzRQdms2TWJSVFZldGxGcDk4VUlBVEpVNmtaYzA1aVNxcnNVbHZm?=
 =?utf-8?B?RGpYdWJxY1VBYndMWllUakdZbXkzTUxQSGlOSmp6N1J0RDBXd1p3QkZVVTZS?=
 =?utf-8?B?bWN5cU81Uk9XSmdzZDdyWWs2M2dhSHBmcVptemhOVlF0alh3anMvdnJISThV?=
 =?utf-8?B?VVFadW1JK0ZqVUpKNS8wTWM5V1BaZldZOW1JSDF0OGljdkFHS1l0dDVnR2gv?=
 =?utf-8?B?U1FOT0w1a1FmN0JVSUtVbnJzYmR5MVdraUFCU1I5ZGViMlNyZ0VtdXdRbEQ2?=
 =?utf-8?B?QnFmLzUxVmNQQjc3bzFHN1NCOCtKSlEwQlgvRlduWVQ3Uk5DSlBJM1BPTzVF?=
 =?utf-8?B?L2JEQzJQYno3QTRzdy9reG1VbXVjQ0tkOEJPNitCQWZSd3hzem5jeGc4bDBP?=
 =?utf-8?B?OGo2dmhyc0gyYnJ6R3VYb3YycXh6LzZQWUlRTFZ0R1d0M0NVczBDYzhTUS9k?=
 =?utf-8?B?aDF0bTR6RzNCZ2ttU2NzanRtTzVYVHNQVmJlSFFJLzlPMTNPc003NnpINVox?=
 =?utf-8?B?NzNnd09tUlRkZ3JHNUs4dWJRY0Y5YjFob3JyTGllNmdMQmFxaGFUK2JrcEdk?=
 =?utf-8?Q?rp6TdAmmhuWdeqwT3x1o?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7574f9b1-dfb4-4c88-7b4f-08db0ba42eaa
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 10 Feb 2023 20:19:59.1023
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iKgru7HBQOZIsiNE5AApNd5hYe8R65hIDQFNS5ZhLkeKijggRB/9eDsI+y1d1RYmOzgiGSwa14UCGO4GOHqmEg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO6PR10MB5652
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.170.22
 definitions=2023-02-10_15,2023-02-09_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 suspectscore=0 adultscore=0
 malwarescore=0 mlxscore=0 phishscore=0 spamscore=0 mlxlogscore=999
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2302100173
X-Proofpoint-GUID: 6JB-zsa-1VpLB1o2s3OCHTAAmJGCNgM3
X-Proofpoint-ORIG-GUID: 6JB-zsa-1VpLB1o2s3OCHTAAmJGCNgM3
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

commit c1c551bebf928889e7a8fef7415b44f9a64975f4 upstream.

sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").

This is similar to fixes for powerpc and s390:
commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
with GNU ld < 2.36").

  $ sh4-linux-gnu-ld --version | head -n1
  GNU ld (GNU Binutils for Debian) 2.35.2

  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
  $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-

  `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
  defined in discarded section `.exit.text' of crypto/algboss.o
  `.exit.text' referenced in section `__bug_table' of
  drivers/char/hw_random/core.o: defined in discarded section
  `.exit.text' of drivers/char/hw_random/core.o
  make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
  make[1]: *** [Makefile:1252: vmlinux] Error 2

arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:

	/*
	 * .exit.text is discarded at runtime, not link time, to deal with
	 * references from __bug_table
	 */
	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }

However, EXIT_TEXT is thrown away by
DISCARD(include/asm-generic/vmlinux.lds.h) because
sh does not define RUNTIME_DISCARD_EXIT.

GNU ld 2.40 does not have this issue and builds fine.
This corresponds with Masahiro's comments in a494398bde27:
"Nathan [Chancellor] also found that binutils
commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
issue, so we cannot reproduce it with binutils 2.36+, but it is better
to not rely on it."

Link: https://lkml.kernel.org/r/9166a8abdc0f979e50377e61780a4bba1dfa2f52.1674518464.git.tom.saeger@oracle.com
Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
Tested-by: John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>
Cc: Ard Biesheuvel <ardb@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Christoph Hellwig <hch@lst.de>
Cc: Dennis Gilmore <dennis@ausil.us>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Palmer Dabbelt <palmer@rivosinc.com>
Cc: Rich Felker <dalias@libc.org>
Cc: Yoshinori Sato <ysato@users.sourceforge.jp>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
---
 arch/sh/kernel/vmlinux.lds.S | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/sh/kernel/vmlinux.lds.S b/arch/sh/kernel/vmlinux.lds.S
index 3161b9ccd2a5..b6276a3521d7 100644
--- a/arch/sh/kernel/vmlinux.lds.S
+++ b/arch/sh/kernel/vmlinux.lds.S
@@ -4,6 +4,7 @@
  * Written by Niibe Yutaka and Paul Mundt
  */
 OUTPUT_ARCH(sh)
+#define RUNTIME_DISCARD_EXIT
 #include <asm/thread_info.h>
 #include <asm/cache.h>
 #include <asm/vmlinux.lds.h>

-- 
2.39.1

