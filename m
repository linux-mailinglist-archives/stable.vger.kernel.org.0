Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 56E096EE388
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 16:01:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233617AbjDYOBP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 10:01:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233401AbjDYOBN (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 10:01:13 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0066D2D76;
        Tue, 25 Apr 2023 07:01:07 -0700 (PDT)
Received: from pps.filterd (m0333521.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDicFx005260;
        Tue, 25 Apr 2023 14:00:16 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=slAHzkdmv/fsKJpEfY5v80zI+lbDpvehZJzyTCKquWQ=;
 b=0nliqMxjbhU8g4vHw2IcADYHNSxToSQ5WT46qTscYPVlliVITr3WcRDuW86q115sF3fI
 24hPJ4TtJiBMS4QUDNPqysKnJiR00Mb0BGaT4toDwwfeesuUkSM2td5EL6wSqsETvS6f
 61S8OCFJDU5SlpGRVvd0jkqx972lxxTLWqTcLlbfYM0qctzq5a5noIlwuyZrb3tb92d4
 +PF8TJn8gyzL4YdMqUFxP3HAkvPQmzzSeLWbooyCvqpEjSjo1qX5i2pyqHUzc0Vi2YhQ
 /hJCakc0u1Su3qKhu07safcaBArrPsYzdU+HPJ0uMe+8xbkSApGWXI4RzPblS0GjVAkp xw== 
Received: from iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta03.appoci.oracle.com [130.35.103.27])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3q46gbnf38-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 14:00:16 +0000
Received: from pps.filterd (iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33PDtTbh024915;
        Tue, 25 Apr 2023 14:00:15 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2047.outbound.protection.outlook.com [104.47.66.47])
        by iadpaimrmta03.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3q461cqqk9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 25 Apr 2023 14:00:14 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=LKmSWBYgZcPEVg3NjDn2NLzs/aqmQsfbG1ehThMV3p29MVb+yRpkUZgfxiEoJEWX4rz07xfTXWtxyBre4OXizNl8z5RtTUX0Unf6jI0a3gFsze7+sGoPm4ouoUI08h/fMAaM6PQYyBkkb8lObE1GAvVtmhi0pd3UCs8AYL7S766AZnjCuT3LLAPoi1hVFoWt/hxC9xgtEChmHQZxlcxcB4IuAIgBaOP6s+QF3yUdYH5h4uO3g3eCCFmRn7+6OC3rcVCIcyfvupqDd+kOxRxXnr6BwfH2AUYc8tv5976RrfXX0p+LgHuVzZ/fPj1hD/fighiwrrzzXp0CJvCcrTfItw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=slAHzkdmv/fsKJpEfY5v80zI+lbDpvehZJzyTCKquWQ=;
 b=FqnF7yaD92wDDgWYzX4/gkwhUAt0OQhNW0GPbyNDbMQxV9yVcPLa8nw1HYDNlnyyYAfdrAIaqz0rdpWfnEDF2FPhuGswtZJMln3RANcN3yCiTj2GmUbJNGJ6v85Ox5tTZpDMHiYFzQrwbaAgmkIVdzt6V2K25KIBgYa9wowopFHVlehUWZHt8CRsiK2ssrHsKfaFOjfSjh96vXsHSt/nTgIh9CjSmcgmh1Wem5L5itVJQmg66RX9gR8zjo3LmWHw+NmRbG2z2I1uN0AVYRUVPOqLsnBlymLM6GI7LCTC5HebzDmbeuwlkJYwPentB9krERoK+r2ev3nDlYT66JsFWg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=slAHzkdmv/fsKJpEfY5v80zI+lbDpvehZJzyTCKquWQ=;
 b=t+xaQz/xovq0E6Wr+gYmV8oUZG2zGVRk16VRnJIJKocPcVOew9Eq0Tfy1rS9OVzOOmJBLZ2RRi0ngExNYab4nWc/zW+VwnBt9IWYfx/Q73/8ufLLDHcmDuCvBImnoyUGNdKJmrMq3esLiV2pqf8KVtkoiVN+seU7+ZSawKiN5LQ=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by PH0PR10MB5846.namprd10.prod.outlook.com (2603:10b6:510:14c::20) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6319.31; Tue, 25 Apr
 2023 14:00:12 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.033; Tue, 25 Apr 2023
 14:00:12 +0000
Message-ID: <5793aeda-f59c-7b82-caac-a13c83b0cd6c@oracle.com>
Date:   Tue, 25 Apr 2023 19:29:59 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.4 00/39] 5.4.242-rc1 review
Content-Language: en-US
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        stable@vger.kernel.org
Cc:     patches@lists.linux.dev, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, akpm@linux-foundation.org,
        linux@roeck-us.net, shuah@kernel.org, patches@kernelci.org,
        lkft-triage@lists.linaro.org, pavel@denx.de, jonathanh@nvidia.com,
        f.fainelli@gmail.com, sudipm.mukherjee@gmail.com,
        srw@sladewatkins.net, rwarsow@gmx.de,
        Vegard Nossum <vegard.nossum@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>
References: <20230424131123.040556994@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <20230424131123.040556994@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: SI2P153CA0021.APCP153.PROD.OUTLOOK.COM
 (2603:1096:4:190::20) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|PH0PR10MB5846:EE_
X-MS-Office365-Filtering-Correlation-Id: 701933d4-a4ae-44b0-7fd0-08db4595634f
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Xl24JcCfznoo4IZoJIK5HZ4bIHH4sztpremXzljB044HFU0h/yHxCWARrD6V3FZRZ9jJLPRTOaTze1fqVE56y1k09hn3+NzdZm2YlT/17/ziTlvL2rSl8lVQtw+z4pTuLKBqMTBVvO71MbDLCzxC6o/Mz4sEwYvwx2RA+WUcpzgM535r99PvPNTjcYhcpXAa7Qxkm/31IPA+NlOn4c9TXYmcE9VnuM3bFGUrPs0hZMN/dMIveLALZ2hgVswodWl5h1DMnDBUv+15b4WuNqfvs0LF9f6M32MK5YN+/NR6SckwiIqMMc5eNALDXpQhiGfN3vgIeE/Q6N7YJW0z74xksuxZytV2hTGHEEAqm/tXHH2ZC9pTZEkrJu8TBRUrtOE7ZaZm9iXQnXkLDr+Q37Nw/hNOAxFP6//hEKlzFpxLW1HtMOOzd8zggKoWGah7Wd7ohCvuEojC/FrrizV0AhwikUZkw4YEcBu+mdcoACy6JxZlivlH7ZvbBk2AIbhS/26/v10kpGKZ7gQo7LDQDDt68jIzQdEdQbr7yKO8FAs6WCkPwuAJfOvAzhqw0wxdGfTfGwH7Frhz3ckuBqlYTGU22RpHckrwhHNtdvakZ1L4u05uHZTxJnTnOnbkJoa+z9TU5Duc/kzqz61m0CXRa2EZLw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(136003)(376002)(396003)(39860400002)(346002)(451199021)(66946007)(66556008)(4326008)(66476007)(5660300002)(31686004)(107886003)(966005)(53546011)(6512007)(2616005)(6506007)(26005)(186003)(6666004)(6486002)(54906003)(478600001)(36756003)(2906002)(4744005)(7416002)(38100700002)(31696002)(86362001)(316002)(8936002)(8676002)(41300700001)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?YlFNbi9jaEdlSnVQZW1hWEw3UWV2VTdGT0RidTN3c0NHNDhhR2JEQlk1eDZX?=
 =?utf-8?B?TW5PbjJsZEdGeXJNeWhXV1RHNXNpVnR1WEVFZ09iZkgvLytLNEVUL21oU3Jp?=
 =?utf-8?B?TXBhUW0rR29MbzZ1eWpQaUZzVkJzdXl5WHU0NXM4N00xbURlSDVzZGE3bGJR?=
 =?utf-8?B?dFhMRmFPZFBoMkFWbkthcy9qUGtENlFkR2hvelg1b2ErajJhM003MElnaS9M?=
 =?utf-8?B?MUtTdVJIQk11amFwQjVlelFTZ0RJZ1RvV2tqeWtaNWxFRjAvR1dvek1YM3lv?=
 =?utf-8?B?a1QwOEx1VjNjUjFIai85dWd2aGdiQzJYTGp5TTVjNThFQnk1MnU3cTFCK2xS?=
 =?utf-8?B?Q3p1dkFTMVNmdTh4c1JaUnVTdDM1bFBLdU1tUE4xbEZ4OGZZVDlMS1VGOUo5?=
 =?utf-8?B?cW9tYWFDK0YxaUtKVWZpZUF4WEV6bGlwSVhiMGlFTVZ2VTRhQzRIaGRGdld3?=
 =?utf-8?B?WVhWQllHSzRkSmp5NENmSDdHVlNxSytSZnV3Z05qUG1mVGpVRlZBam5uL1Zq?=
 =?utf-8?B?ZnJRcHhiak5sNVR1T2NRNHNVc2NNVW5NcmhMMVUyVmJVOU5id25SWGYxZ2dt?=
 =?utf-8?B?SUJrV1h3WG15NHFZMnZsVWQzaGllcEtPYmVtb0tnbmd4TmhQb1RjRWdRT3Nl?=
 =?utf-8?B?T3VDVENsZWhad0s1bDAvOG04NEVFdmdmYnk1Mm5OWmlramM1R3cvLysyRi9G?=
 =?utf-8?B?SXFqeDdyZmZoWmZsUzRrWmZoZmJzbXZIY0xud1ZvWlk2OXhqMUZaSzVTR1du?=
 =?utf-8?B?d3V3VzlGcjV3UC9heHg4UERRVTljdGtPTTRuVjdldk5qTDg3VS9xN1ZyQzRG?=
 =?utf-8?B?T0hxNU51SitwMGpHQlpUeHlMQXI5NjBLelZvZEVqWjIxR0x3UlhrWkhNeVcr?=
 =?utf-8?B?S2FFOTMwQnpMcTFmTTNyVkJsbzVZTmlkbzUvaWkvelhCQVRvdFpkVkR5RnA2?=
 =?utf-8?B?ZjliaHRnSWgzMGk3SWc0UEJKUXVuWnloSGhXYWR4aUplUEFOZ1NYR3QzNGZq?=
 =?utf-8?B?dlkzWTNOTm1QSjRZUkd4VlMycU4vck1hQlJlQnBTV3hMdExpL0ZsQ1dqYitI?=
 =?utf-8?B?V2pTUTBBN09zYTJPM3BINWtoOFNUL2JYWDJlamZ4NHY0YUJvTDFHMmMxZjFy?=
 =?utf-8?B?NHVjclovbzdzRHNvSFhNUzNqN2J1RHYyTlZHYktwTlRSY0RyLzVRcEI0djQz?=
 =?utf-8?B?S1A1SmRRTXV0aHVwU0JaYXh2MWJiTjQzcmFPVHNmK0VpblVRaFJLUDg4VVMv?=
 =?utf-8?B?bXkrclBOK0hLMzFBeWttZ3l6TGR1Y3I3REtXdSs4d3YrVVNCaXVReDlSNGtS?=
 =?utf-8?B?QWYzenI2bEZLOWJvSFNad1lRNmw0ZTJWOVJvY2FRSkxyTlg3M2hOVi94a3VV?=
 =?utf-8?B?L1UycUdFa3Y5dWppY3B3NC9qNXJMRk1BVFNubENCTGpZTTJnbjhtNGRhU1Nh?=
 =?utf-8?B?c3hpTndvbU1ZNTRXdmhWM29WdTNLMHlNdkk2N1V0c1J1ZlBWTW8rODZESElj?=
 =?utf-8?B?a09jVHVZVXlHZTl3SWF1QXlCaUNLbUhpZXhqYWM3NDFOMWdLeGxHNERwS1Vh?=
 =?utf-8?B?WktWTlI1eG9iZXhoUmN2SDRESjd0ODFmQnQ0YUJKVkJnMmR2c3llK2JzNEg5?=
 =?utf-8?B?UWRyVXYvL1VNVkJPbkszWlB6QmYxRmpWQ0lEOCswbDBTcG9zVStvZkNtTXhO?=
 =?utf-8?B?MUE5d09vTmU2SXZrbStqUWdtZDZyN2pZM0xrZnkrblRBR2d0RmN2OEVRVi9Q?=
 =?utf-8?B?ZEhCbEpoU2tYQU4rZU94WmRoMjBOdThLbDA2aEZpcG1MOWUwNGJZNVJkYUxl?=
 =?utf-8?B?bXF3MXdHRmFEL3dmWjhQb2pHN3R6N2lhN1dHbXVuMVZhRStESVJCV3NSMWhi?=
 =?utf-8?B?VElmb2s5UlMrTndjaWFtcEFETTd3aU01bmhBanQ4OFVrcCs2dldtdGV2U3JL?=
 =?utf-8?B?Vk1XSk5VSVZ6ZHFHcGRMVWk5d01ZZUVCRy9NM1l4LzR1a3JGZ2VTSWJKRTgr?=
 =?utf-8?B?aC8rWlNoSWdhTHN1QnRwMFdVRjVrVy9jODhQbzdmbCtlc2tjM3c4c2F0VDBO?=
 =?utf-8?B?RTlsdmY3OGthTXZ1cFcwVVdxb29taDI4QkhUM09hekFOQUd2Y3R3WExNL1ZU?=
 =?utf-8?B?QTRoSzdaWERIYjJVNVIrcTlheVdYancrU1o3ZU1PcmJ3QzZQZXJ4VWhJRUVv?=
 =?utf-8?Q?piKi223u7nL3R0/wUJaUuWg=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?RlhiekpZOWVzMlF1aXdNMzcvSGZIK3dEN2dUSllzNklqaS9rQlNuMzBxa01l?=
 =?utf-8?B?R0JoQWxlS2poYmZOcFVTRGFEUVJQTWppT2hmckovUTE2ZVVHVG00c29QU0xU?=
 =?utf-8?B?RTNyVFdBeC9GSXQrNjBtVjNxMG9GSzh1NEdXN3JJUXpSYWlXaUxySENheExp?=
 =?utf-8?B?NUVWRFd0V2w4enNwRjRqWXF5UUhYM0FCSlZhUnVnZ1I1Vk4xTnVKa2FZZWdB?=
 =?utf-8?B?cjk2WEIveXI2L3MwZFVqWThvTnJqSThSaXZuM0ZqTmFaQkNib3NIZDFrLzBw?=
 =?utf-8?B?SHlWdlNEdFc4Z0ZEdjgzWkY5OUo5NXBOY2FmVURiTEhhaDlTWW0wdVZKLzVW?=
 =?utf-8?B?WVZsQThaOHo4MUk5YXBPblluWk8wSjhqUkxGbkNmOG9jeGg5L2ZWVjJ1WUU3?=
 =?utf-8?B?NGFnSTM2Vzh2d1o0Z1loOXZ2NjByby92cXVucENQZEV0ZmxabjVzMWFnYjhw?=
 =?utf-8?B?S3dhSDUzOEhDMkloMXhlUS9xdFhhTXYwSDBFQTBCTi9uNExleDNxd1YvM09r?=
 =?utf-8?B?ZjZqbjJjOWdZOGZ1V2ZaeVlJL0FyMEUzZi81M0NjSlJPVDBWdzdDaktBMzB3?=
 =?utf-8?B?dGlZc2dKK2xxaXpGTG5KRmFxMG5RNjVwWWZOL0VOTGNsbEgwb0hmeXdwQ1Ev?=
 =?utf-8?B?d1NWTm5uOVNsQzM1Zm9oaFpKUVNCZWhSM1hUbDlZSXA0RXFXYTZ1bXZ5M3d1?=
 =?utf-8?B?cWVHWkU0S2s1VXhRbHQrUXQ2SjErLzlobGt0NEVXeFFFSkIwcUFOd3BkNGtV?=
 =?utf-8?B?NC9tMXRyOGtERVdvbjNmMGlzbjJkTXZhbkRsUDA1UmVZelh0RlMzbWJ5aVMw?=
 =?utf-8?B?d2NOZDY3UGRqR1Nzb09rUldpejQrVkZ1TWV6N0FZZHk0SEduM1YrTkpmZ1Ry?=
 =?utf-8?B?WkZPTVE4c1kwK0loeVdIeXZFeUIzZkVxTlA0MXhtUzg4WmV2ckhmMCs4U2la?=
 =?utf-8?B?MXFLdGwwSmFHU2JOZVFMTVNhZElrd1R5M3pEeTkwREUxeVFRc3dPak1OaVo2?=
 =?utf-8?B?YXc1cDVqa0ViRS95V2VqekJDcHFnVUx6Z1JXaUlDSkFxQk5hY1puWVZaQSs5?=
 =?utf-8?B?YWpxci9qanpPSm1VSU5EZzBlQ2lObXBObldMMGdxdXRDdnd1MWZHek1nSHVj?=
 =?utf-8?B?MUV2bUZ5OVUydC80MkFXOEpVd2EzSmN1SXlHbHErL2NDcVNuK0RHTDhVSm1I?=
 =?utf-8?B?b205REJsVzBiRGJ2SzhUVmRQbEZBR2N4bWViRlZaQmNvVVh3bjJyNU5YRTFn?=
 =?utf-8?B?ODVHNVJHa2duMFMyM090WXVQYmRDTjloLzNkRGtHMXRCTEZmTVAzbktYTzlU?=
 =?utf-8?B?SGRMMGYvdmYzWW9RRUNvZndyQXR4UEZNT0o1YkRIWW5LcnhXMml0MDA2Zmsy?=
 =?utf-8?B?MXNIc0kzY0kwS2xpYkVqeENOR1RWSStuY2RGWkdUQysvUzZXSkZzVDhGeDhC?=
 =?utf-8?B?K09BQW9iSE9zMW1scjJwa3p0ZndMdnNvOUIwT3h6WkZYMnYvbG11MGFyNzhR?=
 =?utf-8?B?T0ZLby8vQWQrRVErWmxwdFA3Q2hCK0dXRk1iSE84Y2RYV05hbUZ3TU5lWE9s?=
 =?utf-8?Q?Wpagx4TInUP6nLuh378NjPc7516DoM/QWD86OU9kwILuqJ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 701933d4-a4ae-44b0-7fd0-08db4595634f
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 25 Apr 2023 14:00:12.4854
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jTvjjPrGJrl8EIbZ/fTvCxa+tcC73A1zVllu7sxnkpBAI/XGtEmsDIpZkCIZKNnOfYVq8CX6I9U4tF0RDBocj4YO7hoYxDnDxs4cRdsExbEevUTpg/ScCQ6GDwpB1XgZ
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB5846
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-25_06,2023-04-25_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=975 suspectscore=0
 malwarescore=0 mlxscore=0 spamscore=0 adultscore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2303200000 definitions=main-2304250126
X-Proofpoint-GUID: 1fyz7oj_7tNN7a8IdISTSwXLM57x8RMN
X-Proofpoint-ORIG-GUID: 1fyz7oj_7tNN7a8IdISTSwXLM57x8RMN
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Greg,

On 24/04/23 6:47 pm, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 5.4.242 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
> 
> Responses should be made by Wed, 26 Apr 2023 13:11:11 +0000.
> Anything received after that time might be too late.
> 

No problems seen on x86_64 and aarch64.

Tested-by: Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>

Thanks,
Harshit
> The whole patch series can be found in one patch at:
> 	https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.4.242-rc1.gz
> or in the git tree and branch at:
> 	git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.4.y
> and the diffstat can be found below.
> 
> thanks,
> 
> greg k-h
