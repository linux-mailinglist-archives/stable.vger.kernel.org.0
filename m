Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACE416A7958
	for <lists+stable@lfdr.de>; Thu,  2 Mar 2023 03:08:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229623AbjCBCIh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Mar 2023 21:08:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229803AbjCBCIe (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Mar 2023 21:08:34 -0500
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F5F9521D8
        for <stable@vger.kernel.org>; Wed,  1 Mar 2023 18:08:26 -0800 (PST)
Received: from pps.filterd (m0246629.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 321MvR8W013690;
        Thu, 2 Mar 2023 02:05:41 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : in-reply-to : references : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=Z13ow63K+inpwih9l+l2PAW7UpzCsnMvb0eY2lEBYzYPy0r7IqN4r2lHtrEB6PL8aFby
 BFktwfB2fVcFaJX+uak/w5FbVsvRtiFZUj0/LAOFfKpL9eDwRdwwL8FmBhrKq0Rdn8Sb
 dIia/Ut/T5mliMFs++LENsYb9w5JWUYabdjWkGT7VGn53c6mewQIKKW0lPRYbTflEqi4
 JMMaBpl89yC/xK4JVOifK4YTgBdkKggE+IdEjNHtng/qq8ZXMwqQcnGF4+YHvkH+aNXV
 t/AKOTwIgf9aG0I9HMSAzPo8PZzzYfRHtRxrqsKXFdsv87k9hP0HWGBh5VwcJuuSneLf wg== 
Received: from phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta01.appoci.oracle.com [138.1.114.2])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3nyba7jda8-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:40 +0000
Received: from pps.filterd (phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 3221cjCW032984;
        Thu, 2 Mar 2023 02:05:40 GMT
Received: from nam02-bn1-obe.outbound.protection.outlook.com (mail-bn1nam02lp2049.outbound.protection.outlook.com [104.47.51.49])
        by phxpaimrmta01.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3ny8s9c875-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 02 Mar 2023 02:05:39 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jT0TQVb9qW3CKdeYifqFMqKqqZwRxq0nbPeMUjF/iYPsqz4reQC0NM13vrJ8kTTaKjSEWk39//DduiUnoemM9HtIeMVucUkh1UX80lVag+tm32U8Pkd+XBmdqMZBujMIpUBvyAshLAXinyCFTHT9p2rceeTQWsUMGiTYDj4Q7kTW9hvywwyAqkEWaMRJj4taJPxXGFkoejuvMHlm/ZlISP6aeX7sxPexdXCFXDWiQk4mNrvdApRGzDNJ4JrpzAoxbfBTgzNSySUHYCTU6+/3d0ZSaXFPWeH2aN93eIcL5hI6s1igFu5c2Q0PExejyPmzRCvWNrb8VxSG2pCCKewAfg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=BgKQPUBAxZaguEef2ECYooSbK3yY78hFyNtDSaS9TSt9/9Oc1TV9RgrgMHLq3BNVo1/Sw8HiKdf+gRw8vIb8azG7a3nrA7+XJ6Jg3+zhKk3u+BQhSyaaAc1DlHq2fETyfU6gKIextCv+CrfIvUBfzfXWbocayuSPHUKWn20Su0EUue4W0oITJ6uYJMbb1Adl2yb3uzeD8s2i4+vauJDQ5XTTAjkK7DAUcEURM7aoB5HMgqVowTahA+W4TMpq2NjrIILzoEnWKQHvkrG/xCzmCikVFYTqfXrGNmQMYByAOUcgHVZwxh78UjEtXVosnqclUaGwQMpP+/tVd7B1UgCFnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=3jLTDVfT6HYQkiXuTu7dZ0AUyWdxQyRqD/EqYY4DWgs=;
 b=H9nGmDGBH1JBfj7SPTV+0fHpAE0XrOSwkIHIGSmvW9ze0PrMJBkE2x84BcizRBwDGEkIESu/Fq3Rd4Qv2Lq6xR/WpsjLRGnWu/vXoCBNFNmkmPRhQ6Uk+S+U3W4xqDE0YuZdaLeW8uHjcACuqgn4miQMUnDpttRe6hrNZIHJFIE=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by DS0PR10MB6872.namprd10.prod.outlook.com (2603:10b6:8:131::16) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.17; Thu, 2 Mar
 2023 02:05:37 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::df97:c045:6f0c:974f%3]) with mapi id 15.20.6156.018; Thu, 2 Mar 2023
 02:05:37 +0000
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Sasha Levin <sashal@kernel.org>,
        Tom Saeger <tom.saeger@oracle.com>, stable@vger.kernel.org,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Ard Biesheuvel <ardb@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>, Christoph Hellwig <hch@lst.de>,
        Dennis Gilmore <dennis@ausil.us>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Rich Felker <dalias@libc.org>,
        Yoshinori Sato <ysato@users.sourceforge.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.10 v3 5/5] sh: define RUNTIME_DISCARD_EXIT
Date:   Wed,  1 Mar 2023 19:04:56 -0700
Message-Id: <20230210-tsaeger-upstream-linux-5-10-y-v3-5-f7f1b9e2196c@oracle.com>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
References: <20230210-tsaeger-upstream-linux-5-10-y-v3-0-f7f1b9e2196c@oracle.com>
Content-Type: text/plain; charset="utf-8"
X-Mailer: b4 0.12.1
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: BLAPR05CA0046.namprd05.prod.outlook.com
 (2603:10b6:208:335::26) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|DS0PR10MB6872:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a981cf3-eb32-44d8-e20b-08db1ac29d67
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: x8F7JMwWBf5PlUI4yXDrvr2yL6inkyMcbzo9o0feWz4ctQTmDGV2hsqG8FGz/DOYCb4ytu3Jo04P8M0TX9yHDt/xg9RLuk1bS9PzczZ23vLNCeOnwGs1LCR2UJsrQX9ypfs3rl5KMpTcHC6p+AJ+Mo2AdIyysOkJx738vSP8tSzSkwreBNhMHpIqv71VESG3DuG6RtLh2+67skIWeQIrVJa3uRPlNIYFCWFDb0Nv/KNHR9NJsU/M4lrltMQL8jHN8/WOzs31Q+UTNTbip01J8OJjofxCEqbznK163A9+lzBpdjeKF1H30N8Y2/97elJRsqKz0gY4FX5OEE417bBqLirqMvTsQcuF1B7fJ+5djSulA5Hk3b/0XZc5bUl2acSjA1WYPZh12TcuYuVksFKYvIUFPfoWtBOYVtMAZNgdO3VIHKH28EKvfU8Vj/iB3fngz1lJUYjgZrCyHsuRWTHdL6Cxu//O8eOUb811ZIoUxDwFTAw5ooQ5hoMe1hqKjEWYoNj4klVEqfbhOpXf+lOs8LIk6kqHKoB9mSwegc1PSyVmNJEVov9gOLewVQfgQToowoUAXFcl21nQdborZmPrc4WXEa+jh3VzI/gP5kmuZqsgcYrcrnWiYwpBU59ZKJ8BC6QQl8XcrlsRdk9U6QU5cVev7UV5SSKmMfhzW4Zm82k=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(346002)(396003)(136003)(376002)(451199018)(5660300002)(44832011)(66899018)(41300700001)(4326008)(6916009)(8676002)(8936002)(7416002)(66476007)(66556008)(66946007)(966005)(316002)(54906003)(38100700002)(36756003)(2906002)(6486002)(6512007)(478600001)(6506007)(86362001)(26005)(186003)(6666004)(2616005);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?c1QwSU1WOFphczVlZW9mWExXUGo5VDIzVEl6M1BvRElhWVN5V3NqalU5ekFa?=
 =?utf-8?B?OHZmRloreGZGMmNNaXhrakgzT01PY041RDZPMnVmMXVURXhnajVBeTBuL3Bo?=
 =?utf-8?B?ZzJzRnQxZmJJczFpY1M4dnZ6d0JYYWMzalUvdnVQOGcxeEtSZkFPLzkyZmc2?=
 =?utf-8?B?L2JkUkNsWnE2a1BhdzAwdm9rMVExMTZXNlllN2FScWVMcFphdTdYR2pKSGJs?=
 =?utf-8?B?OVB5WUFEU1FrUmJpVVM5WUkzWE9HaGFzUUk2WUxxbHRlWHpBN241SlVDTDQy?=
 =?utf-8?B?bFZOU2JZQmxPZTBHZVFoZS8wZFVyb2dIb21CN1NyWHhadndOek1STUFERzlQ?=
 =?utf-8?B?NTZRc08rdE52UUF6MEVJMEE3M044VXVYTW1VQzNJaEZaOSt3OE1xVmt3WHZS?=
 =?utf-8?B?MDVuYWc5UTB2R2lPUDluR1h0SndMNUU5ckd2YXJONDlRVERETVVMVHVpanJU?=
 =?utf-8?B?aE9xM0N4dUxiODBSR2QvV2VUUlhaTXlRWUhCZnVZTHNlTzhsOWJOMHBLcDNa?=
 =?utf-8?B?c1doMzZJSFVIQ0dteHdCTDhhRFZxUDhLWDVBR2tONnVLbG1odDBWbkZwZktj?=
 =?utf-8?B?dURib245Y3hQc1JxenhYRTNjUEFteW5Dd0NINDNKVnRGemVKVUhJZWJyelNM?=
 =?utf-8?B?SXRMZE1Renluc2NBZWdid2crYzZvK2paU0E0WU5oeHBwd2k3bnpmT01Zd3VI?=
 =?utf-8?B?OUZhMTRybzRPRTdReHVhcWtONXV2dTRJQWRFVTV6Y1drY3NwQ09vRzlsckQ0?=
 =?utf-8?B?bU5xbFZCWWg1TmcraFIrNHRKVU5mSktlcGpmNnJ4S0MwbHV2MkhNSTUvSW0w?=
 =?utf-8?B?Z0JoVld5VG5IbE1OZjh3OVdTOGJ2SmlrODJBb0N2M3MvWk5UbDlHeHlEQmZy?=
 =?utf-8?B?K3gwRmRGQlc5cDBPV1RWM0lnbWZEdHU1MWZVKzVHWGJudDRJTFVncTVoRTg0?=
 =?utf-8?B?QWdCWTZQM0xwTGZLNGxlQkx1QmEyU1VJQ3N3Y0NxRGFRWHkyVms3K2FJTHJi?=
 =?utf-8?B?ekNoSXVQTlAwWFJzUTFpSEVJSmFFMk54ZU1mb29UVTVMQU13RE1iZjNremY4?=
 =?utf-8?B?UWh0bGVoVmdLRDdSZUxmdnVPM0RHVE42VzhMZ2VpdHBwTkwrR1liMXpiWDEy?=
 =?utf-8?B?UXVRQzNDWGY0WkdHbFcyKzlTU25jUlpOeEY4cmpzSFFKTVhkanFsc3dCSnl1?=
 =?utf-8?B?U0FtMDluSFVzNEFnUGxIWUhqT2tyRHFqQVlFZ2xCcTk4TTU5cm9tdzg3d3lW?=
 =?utf-8?B?TmM5NUFlT09YYnlxTDlZY2lmYkIrRzRra20zOEdPK2Q5dHJ2VWhZcnpGSjRo?=
 =?utf-8?B?SnUzVkRkb0w5ajdMcFJjT0NIazNPR2JEWEJEOUVTUDNzeXB1dHowNWpqWGFa?=
 =?utf-8?B?blN2Qzlpeld3NFVaRi9MdWpWVFZZcDVLbnVzbzR5eVFBcWhMMEovejhIOFBD?=
 =?utf-8?B?aXcxR2Fhbk5HOGRNQ29qOHR2ejE3SHVDeVUrT3hJV1MyREdiZHV3eVRucmZG?=
 =?utf-8?B?QzJrUml5SG03MTFodW9yRDFFbmlWbXVsUWlZc2ticHdrMGZWQ2V4UURSc1ZU?=
 =?utf-8?B?STVYNjB5MnhFMUJ6NTgxR0pNZFRwWTJ2bzVianB4MGhqaFlkaVE0bGJ6Nk9r?=
 =?utf-8?B?anhxTWs5aHNsTlQvMEtreFRUZ2JoMCtYa01Xd25GZ3FJSlRpd0FpcFh3OG05?=
 =?utf-8?B?bFJjeXpDdG04dVhmNUFodTJuajJFTGRhcGIyNVJHUDNYT3cyWWhza1U3ZTNn?=
 =?utf-8?B?TGpDR1FGcTdjaFRtOUZ5STdMYThBM0VKUlhFeXB1eSs1WFNYU1gyNDhrNm9M?=
 =?utf-8?B?VlN6bzRxN3NIdWlBR1hMaUxrL2VQTDQ2OGR2Q3Q3NTJma3NRTG9tZ3hSajRR?=
 =?utf-8?B?STZGZGdTVURzRHFaZzhxUlgyVmdoWEg3RVJFYkZ1ZzNvYlFMcitRdFhJbEdk?=
 =?utf-8?B?MTlNb3VhNVJzNlQzdG1rQ0RFK09na1loZ04ySFJQaGFnSXpVMTJDVVhuTC9V?=
 =?utf-8?B?azdsekNDMjU1M0szY01RbUFMVVI2V00ydDAzZzIyUUdKZ29VbTA1RzVDbkw4?=
 =?utf-8?B?bHZNUXJYNnBLdG9qMURRQVd1T3VEOEhGMU5pNG8ya2xrcUh3UXdNNTdPaHRS?=
 =?utf-8?B?MEZ5akFuMFY3MlQ0YkxEU2JZcENWVjgzS3VrQW0zWnkwYmZFOERMQzR4djV4?=
 =?utf-8?B?MlE9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?NWRwR1YzZ2FMbEFSNFlkbGxZNGptZEk3bXNnQnNrcUtIYXFOOEdLcjZpSUJV?=
 =?utf-8?B?dnh5V3BsZDQvVmU3WGswRld3SEFOVVdlTTB0dmprR1prMlRiZjdTMXMwcnJq?=
 =?utf-8?B?b1RhdjlPR2M3ZDkwbUJrUUhhUzNtNXcxd3Q5UXhwMHdrTTFKRlU0WldhVUlI?=
 =?utf-8?B?ZzBIU0RUYks0Z1NSbDdRT3FGcW9TdklnUkZjQXd2cG8wNzZwWjJCNWlOZVpv?=
 =?utf-8?B?S2VsOUsyMEI2cFA0ZkN3VVh1ZE9oaTNhaDFnUHM2UXJ3a0FMaTc4NFB1M2Ur?=
 =?utf-8?B?NUlrSE9PeGlweExxR2JMaDFYbDBsRDlPbGF1d1o4R3ZBYjBvWXhKSy8ybUh3?=
 =?utf-8?B?UnVmM2RyTm44dkxkbXg2TlVnVVNBU0FSaVBrQjN5U0N3MFZsaThGVnR1K0Rn?=
 =?utf-8?B?aFVsVmxJdXo3Sm83djJqLzRmSDVHcmczNFNibFh1ZU1YV3pMTGJzeDQzV2NG?=
 =?utf-8?B?M2FDK3BzM2l1U2V0Mk1RRnZGUGNDa1FXQmx4V0lSK2FabHpZQkpzWGJtajFK?=
 =?utf-8?B?WFRHdjJpTWtLbk5DVVp2aXVIRzE1cUQwTEJuTlNvbkNhZDAxaWRpRmYvOWxk?=
 =?utf-8?B?elljZDlVOHhaOGtIbWNnSUw0YWpWYzdOSE50akdPbFZzUk5XcHdtTXV3U3Nz?=
 =?utf-8?B?R005QlEvQWM3ZzZ6WTNsYXhrcEhrcnV3VUQ0MXRpUXhTdldxaCtiV2tyczdE?=
 =?utf-8?B?QWJVT0VHU0JxYXdlNFM5RS9mVTJYcThhalhYV0s1MXdVOGpjcUZMcWdjcUlK?=
 =?utf-8?B?NnYrYU9qUWhrVWdkVENJUnkwTHIyYmg4UDR6c3JjVVU5MHpSTHkvUWJaa2Rh?=
 =?utf-8?B?TzFleEhZYThSZmJucmhlZ1Rtamd1K3lrMVBrdExBOU01NnVPckdZYVRGQ2tQ?=
 =?utf-8?B?VVROM3MzaWNwcllKQmNKVEFJUnVTQ1E3ZDNGRzZRTWlsMVVYSDJjWDAvYUNi?=
 =?utf-8?B?Q29NQkZpUkIzMW1lNkc1eCtXRTZQM3Z5QzRiS1hHNTNhcHdHcE5oUEx6cWR1?=
 =?utf-8?B?TGptRzhCT1pYWGVQQXdraVI2aDBoNnhqVDlEUEVsZHl3Q0pBRldpZ05pSXEr?=
 =?utf-8?B?UHd1Y3ZYL3Yxc3dvYSs2ckpRcnhTYmg5SGoxWUVFYmF0b2xZd211YytBTVRw?=
 =?utf-8?B?ekQ2Y1BQVG1EWUtxNHRhcDc1YTZqWG1TUVJEdEpOYlhNcW1wZ2JVSmFkSTU2?=
 =?utf-8?B?TXRHSWtzbW5qeFA1T2tiT0VINFlMNGlTUTlpZ2lvNjhmTTd1WlNPZEx2VnF6?=
 =?utf-8?B?VHZ6cHVjN25tYVMwVGE1QTB0ZElGT2EwTHArTVA4M3k3SW9ER0pvY2hPd0Jt?=
 =?utf-8?B?bmxNTTFCUHphUWFkZEYvT01LVnhGSHl3V2FWYmhaa2dQME5ieFFySFdSTms0?=
 =?utf-8?B?NWRFakhER21aM3dLTDdLQ0FCeHcwdGxlVEZiVDRpZDRRanJtSnFlNnJnYmlD?=
 =?utf-8?B?WGQ5ZmpKSHpmMlBXa0xiTVZVYmZVL1lZWk94R2VYdW9Yc0pBZkZWYW5aUkxP?=
 =?utf-8?B?Y2FRbmNnNzlmd3p2TzM0MVlDcHQzcmgwQjdFcUxsUTQ3V3Jtajh4c21LdEJ2?=
 =?utf-8?B?clpqQT09?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a981cf3-eb32-44d8-e20b-08db1ac29d67
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 02 Mar 2023 02:05:37.1896
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: t3hpIWJvaBjiWteAl3EMUh3MP4ikHnCfg6P6zQyOyaN4iLKm7gqxM7hdNq13whnE5DPQBk33QxB9kSPgghw23A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: DS0PR10MB6872
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-01_17,2023-03-01_03,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 spamscore=0 suspectscore=0 adultscore=0
 mlxscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2303020015
X-Proofpoint-ORIG-GUID: DZwpGx7l45KY5gypVPkuw6mXd7UHem3Z
X-Proofpoint-GUID: DZwpGx7l45KY5gypVPkuw6mXd7UHem3Z
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
2.39.2

