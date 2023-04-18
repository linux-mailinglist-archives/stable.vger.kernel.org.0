Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C40826E6993
	for <lists+stable@lfdr.de>; Tue, 18 Apr 2023 18:31:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232308AbjDRQb1 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 18 Apr 2023 12:31:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232542AbjDRQbW (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 18 Apr 2023 12:31:22 -0400
Received: from mx0a-00069f02.pphosted.com (mx0a-00069f02.pphosted.com [205.220.165.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7EE6B757;
        Tue, 18 Apr 2023 09:31:01 -0700 (PDT)
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 33IExYbl013947;
        Tue, 18 Apr 2023 16:30:18 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2023-03-30;
 bh=kw0+AFt12chVUaMKD4sIWAoUDlODFuFssAyMh6CMnmg=;
 b=XC3dn+b6Yg9BDsNMKflN5BQbIvvRsji45K1FvDeBnrqS0TWh9J+pythJE3IQZfTqtX2b
 Qv57wvWTF0lj/xj4pgl1F4cYqCksa5rBq7V9G70MK1YtEXAXL5HHdSviH1XgpAPqsYnl
 PaN2ptgSKe5xdbmy1fu9tpoy8UL139v1bUlvFKeH4fRTnyh2QuJ7NMi3vm+vcUMZrgIQ
 iwIwR+j4Dm5eLMRo3vH6XS7iMMq/Vgmh8cUhf9DilD4V4AGDyTB3+9+U3P9zfqcYPobk
 Fn0giUYO6gfPzijkNi4vaJk7JWEVAn8OSYgWUIJEHQcHUDC4lEuy06+kZtaNwIfa8XQp XQ== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3pymfue4uq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:30:18 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.19/8.17.1.19) with ESMTP id 33IFVm5i037363;
        Tue, 18 Apr 2023 16:30:16 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3pyjcbspw7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 18 Apr 2023 16:30:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BSBNji7RX52k4O7kGgRJqb4z9+3cIRAvJ9ePepjcMca14VrAyeba6cwOOADuXjtw66hsGcMjVu0/uzUcPIoOyDKwvhiVjnJsfIoePvYhQWz+LI70kbH+UjWkVK0TYoL01/g+cT2sndYLcQtVJSe/lCZ8Bf9LuLeU+goFtbJlRQsdYJpxc/zRbeCkCWa+uBRQvMUu4PQkWjUJ/GTbufJCjIkSRXqgIt8YE4Q6oXC1R8I8yMm6+Bgrppdkew2unDCDKtRO7oeuO0CJYydvMe8k2Mya4rTOnAcRObCxz/F60nKm0hRyqRk7e10+lkeZOAnIvhTmzm3m0oU/SyHBAgra1w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=kw0+AFt12chVUaMKD4sIWAoUDlODFuFssAyMh6CMnmg=;
 b=JfUGZNKs8ntwbHpAS9A59jW+x+vWQ372BPJPBiAPJnyoey1gtaJH2uQ9Cf39wOWLeUsbYypp1ZQGWBAFWIte4kUFLJFq4LjjAk0UFHS5wWO1cROmBmYnXXBCuW3S+hNQQ7S3KEHxGy0s20GQOtkEl4jRw/KugjGBs+7wtofkocT2mVMx06HBlksALqjPpQ6uJja+dTp+B5gzErGafSTaUmUPl8L8ureZr4+oQkyzy5izyGPp+NzZVPAruBQpTgFF4uB3BKPyFlJ84n//XjbdOAKD1VRvxX7dlF954O02Ny09RjoMbzKAQsMBf5T7qMs0e1e6JpJElPldWYuY750cWA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kw0+AFt12chVUaMKD4sIWAoUDlODFuFssAyMh6CMnmg=;
 b=oXphCMbhGC4S3xkPlBjlN7+94xAz9qEdxR3T0wSoaHAa18TSBelor628EEuCb82T3KAqd8HXZrFsL382CHNOGCmqjwwOdbqnD+oCzP4jVu6IfW4UCt6glSkzno/bgWs4s/B3P7A9Nd2AECuakmIwN13cKMZJjF7UVMVaXJHpbJI=
Received: from PH8PR10MB6290.namprd10.prod.outlook.com (2603:10b6:510:1c1::7)
 by CH0PR10MB4842.namprd10.prod.outlook.com (2603:10b6:610:df::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6298.45; Tue, 18 Apr
 2023 16:30:12 +0000
Received: from PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834]) by PH8PR10MB6290.namprd10.prod.outlook.com
 ([fe80::68c5:330c:d234:3834%6]) with mapi id 15.20.6319.020; Tue, 18 Apr 2023
 16:30:12 +0000
Message-ID: <8615ee2d-a57c-6c66-617b-9215b74b820e@oracle.com>
Date:   Tue, 18 Apr 2023 21:59:57 +0530
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH 5.10 000/124] 5.10.178-rc1 review
Content-Language: en-US
To:     Shuah Khan <skhan@linuxfoundation.org>,
        Naresh Kamboju <naresh.kamboju@linaro.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     stable@vger.kernel.org, patches@lists.linux.dev,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, linux@roeck-us.net, shuah@kernel.org,
        patches@kernelci.org, lkft-triage@lists.linaro.org, pavel@denx.de,
        jonathanh@nvidia.com, f.fainelli@gmail.com,
        sudipm.mukherjee@gmail.com, srw@sladewatkins.net, rwarsow@gmx.de,
        Waiman Long <longman@redhat.com>, Tejun Heo <tj@kernel.org>,
        =?UTF-8?Q?Michal_Koutn=c3=bd?= <mkoutny@suse.com>,
        Tom Saeger <tom.saeger@oracle.com>,
        Darren Kenny <darren.kenny@oracle.com>,
        Vegard Nossum <vegard.nossum@oracle.com>
References: <20230418120309.539243408@linuxfoundation.org>
 <CA+G9fYsA+CzsxVYgQEN3c2pOV6F+1EOqY1vQrhj8yt1t-EYs7g@mail.gmail.com>
 <2023041819-canyon-unarmored-38c6@gregkh>
 <CA+G9fYuSwpBW-_PubGFYsKi08=KrmsR=g9D4HDOvZP5pd4t0MQ@mail.gmail.com>
 <05ebc19b-d497-ad10-b44d-35740d965627@linuxfoundation.org>
From:   Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>
In-Reply-To: <05ebc19b-d497-ad10-b44d-35740d965627@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: SI2PR06CA0005.apcprd06.prod.outlook.com
 (2603:1096:4:186::12) To PH8PR10MB6290.namprd10.prod.outlook.com
 (2603:10b6:510:1c1::7)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH8PR10MB6290:EE_|CH0PR10MB4842:EE_
X-MS-Office365-Filtering-Correlation-Id: a822e4f2-4909-4d8f-d33c-08db402a2eb1
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Ml0azDfz6bPP3cHhQqcROUfqNR1HD9FMPnRqzplNPl1GDGhVOWzKsRRNa59RW5qhdLUXuZLlBvzQQqq/42gTQRjsnRMO4dLCjT5XJUL7OcHVhrmV7CYYCuIW/X+OJO1VIumoKSEdhcZgFLbztz4Z/IC5mlT0LeD3aD7gHzp13rtcJnAbt4NkcVhWiYgwhYOQwJLietyfXZLqwOrxqmSU6v7MDtFwuW3rgP0iDuiVnITvPvRmZqX2VHZwpr4+/ODRnPaosaibmimyS8JDxgimW8sMd15AnQdYcgPrPhg9hjOomR1pIDaqPtzzLuhFEKET2JIkG1A0dlQLFKt2sAWfw6/x4cJS8mOKt62B0s2TDNSCuazIxofNY8lmZ8Ln0EeDHA1SUsJHn0gjXwMIs3YRkh91MCYBw8ofm3ZjS05YOnEx+aoGQ1HnL8AZLXkt/mKq2u9o341EqpTyXO3QPvHGijiCuuKL5s92BrrbQJLQgNKy2IJjVSQCbz641ei1wiFdchpnhQD1Z9ZlAvu6l6QWA+OWPxfS7ABXC5PeHn1FbhgtfZtGSNVdgkiwsR35+6n5J+9yOFP7CkdSmiGpFxkA/NtzpwCt6cc+P/zrBGAsUgobGc+2g7rSm8ASTU9fVzl4ox4OeUbMehA1Rr1lvNq3mSCbFih73K5uvWCsOQkaYbgFEperuF7D76ihKWPEZxEh
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH8PR10MB6290.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(366004)(346002)(396003)(136003)(39860400002)(376002)(451199021)(31686004)(4326008)(54906003)(110136005)(966005)(66946007)(66476007)(66556008)(316002)(53546011)(6512007)(186003)(26005)(6506007)(107886003)(38100700002)(2616005)(83380400001)(5660300002)(41300700001)(8676002)(478600001)(8936002)(6486002)(6666004)(86362001)(36756003)(31696002)(2906002)(7416002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?VkswS28vd1ZRaGdua1FjV0ZKdlhTTVpmaEdWNFk2bzc5ZW8wTjkwVjRYOHZt?=
 =?utf-8?B?TTBqUWdjdTBTaWhjbVdid0Q3NGdjTlhWN2M5SVN4Y0diNVB0VkFFY2Jhdm9l?=
 =?utf-8?B?R3k3Ty9Pb25mLzk1Z1hOcTFLRUJxMXlwdWRPSzRZWWZXSkdnbFVUcmNsVmxN?=
 =?utf-8?B?blBwYUJaR1k5aytuTUZXYnVaZ1kwR1orQlhwWXo4dlQ1OC9Sd21VNkRYdTRM?=
 =?utf-8?B?bFNMaTNZeWxIbXJqRE03b0VFa2Fvalp3WjNSNS95WW43U3RkZ3hkTkhuVjNC?=
 =?utf-8?B?ajJuN284UC9Cbm14NnkyUmZIaUdPS29pejg2eU5tVmFVUEFsY0hMQUt3UmJO?=
 =?utf-8?B?ZGtsczlqK21ZL29nWDZCbHhMNmo2U0trWDN5UllIdjlBOHp2NGhaMlBVV010?=
 =?utf-8?B?eHBRUmZKQzZZV0NJQVZHWGNrRU50WlN5NXUycC9tRVNNOXp3cTBXSVZRRkRS?=
 =?utf-8?B?cDA0czllRUtlZitub2VDb2V2aGQ4V01tM0Q4eDdFUVQzK3FqbjZoM2tSLzNY?=
 =?utf-8?B?VHFtNWxSTjdWK2dYU0xUMGliajlXMGF1TW9qaEFqY1ZnNDlDdnBGVjlQNWMv?=
 =?utf-8?B?WFBLTmwzdWxkOEs3QnRtU2p2UVEzak5BZU9UeWJVcjNzZFhCYS9KY3FrVTBT?=
 =?utf-8?B?bER4WmphOSs5bkwvbXJnUDBNdUNFZnhSOFN5cFJTcEQ3S2FrR2dXdVRxSS9q?=
 =?utf-8?B?WmRTOGZXakY4SnozeUJQSzh3V21OZkpnQk9aTnByQnFsZmRCN1RYMXhMb05r?=
 =?utf-8?B?OTIvSWdVSTNNNWNUeWo2dDZPOHJ3TlpNa3AxcnRXT3kzSFA4NHFtc2NtL0dE?=
 =?utf-8?B?RC9rNW1WRlR5OG4yakxwb0xGNmhmQ3NUdWlWczVoWWd5d1VnWkdsNXV3azBI?=
 =?utf-8?B?L1RNWDZ6YmNsbmd1blFwVGtVUHI0WDc0S0FTWWhmdUxEdzJPbFhWLytQbHlC?=
 =?utf-8?B?UnlmcEhrL1hUbnZQRnFYV3EvRHpYendVYUdKZTY1NldrMlFjSVVtNCtSeXpT?=
 =?utf-8?B?ajR5clcrWHRsSWQ0bDZha3N3c3E4SjlRUFZHUmpFb2RFU2J5N0lDUkl5dVIw?=
 =?utf-8?B?MkdKaGx3ZUFNVjNLNGFReVltSk9PUjJobWpERWtiRkF3V3RyRFEwTFRPUVN6?=
 =?utf-8?B?MHNnalJMdHFjRnUvN1hzWDNOZ3RIeXpoMmN5Zzg4aWJEWXFiN1dsQ2l3Nm5U?=
 =?utf-8?B?eG1aTGhJdU1hRHJ4Rm1sRTF5aUFqcFY1bEhWSmYrbFhreUloYWRhM25lcWVJ?=
 =?utf-8?B?VmhqU2ZNbGphOER4LzRvRHJGdFY0U0crd0VVajZqMnJibmEvOWFrQW5mOTFO?=
 =?utf-8?B?U0hhQTFjRlpFSlBVSVV1YzJxZG5mN29KRTNERlg3a1RZajlFc085RmRaU1BX?=
 =?utf-8?B?ZGRuTmh3Tmo1eTlHdno1MU5wb01HU0RQblZZcFBtc0Q0NnBrQlpxMkJBVXAy?=
 =?utf-8?B?WFFLVisrY1Y1RlVWWUVXa2d1YVgxek9ITHUydnI0dWlvdldxRVJXamk1Snhx?=
 =?utf-8?B?UTZXL1VFZEttZ0JILzdmMTk0RGRNK05xaTFBY1dZZ1h5TXhmVnQyU1Y5Q2Zs?=
 =?utf-8?B?aHgrN3V5L3ZBV2ZxU1JYYkVBRVZqUWVXbDFKT0FzSFQrQXFpQUZnUXdadXZo?=
 =?utf-8?B?b3NhR1JsM0FybTJJcnc2Zi9JZTFOMG9oeWYzUVNYL1JOWUF4L0duaFNKUml0?=
 =?utf-8?B?UUZHbDB1eENZQ1EvN3NWOXdJa1d5Uk1RdTZOMTNMSUt1RFk4dlU3Q29SeHhR?=
 =?utf-8?B?SzV4SVZ2U3Rsend5YjJsRStlelVpQ1Btd1pjWEJFdlZZV2g4dnhjcFoyOVlK?=
 =?utf-8?B?T0cwMWtzdDB5Q1Z5akhwcWJTUXpPcGVhUDNxa0lsREY3TmlKRnlST3lKVi9w?=
 =?utf-8?B?N0Y0WXlDam5WS1pLRlA4QUdMWWlEYVY2NjFxWEFwZUhRaGVLaG5GdW5JUG1J?=
 =?utf-8?B?VEJ2VG5OMGl3eWN3NG9JV2M5WDlFRkFnbGczUW5leFVuekRDdTVOa0pua0Mx?=
 =?utf-8?B?RHg0Nnl5eFFIdXBHaDVzcVJBbkRmUldMcW14OUtxZWx3a0djbnVOMmNScUl2?=
 =?utf-8?B?UlJjTjRYdVdNRi9nZkg2cjEySDU1RDBKbG5ZT3dpYWtaZkhicjY2TjdKVlVu?=
 =?utf-8?B?YjEveEFLUFM4NUJYTDMwTnhvWkN1WnhvT2J6RzlzNlZZWVViU1d3TlRoRkhY?=
 =?utf-8?Q?u5/L8DD7KwXR4nU5+PB3Now=3D?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?bVUvVFEwZHpKUHRkd09NN0NHa3Rpd2ZFRWQrMEthcHgxYlVTM2VQSlkzTVAr?=
 =?utf-8?B?K1JYVGFoWi9WLzFzalBKbTZoTGJkd1N3bkFIMFc4Qko3U2NvekU2c0NtSWxM?=
 =?utf-8?B?TS82a1dRMG9FUXVBUjJNYXJFZEVSQjBwdTY5dENpU3RLRFNwTUJvbFhjSmhE?=
 =?utf-8?B?TFNFUURzTGhSUUxnLzI5d2dPc2NhTzRvZ2JwdUo1TndRKzZIdWRMZVhlNFU5?=
 =?utf-8?B?YzdFblBNZlBSRlVzVm9Cc0pWaG9peDlJVzF4b0JMZlRUSlBBc1M3aFoyTC8r?=
 =?utf-8?B?ZERLbWZhdkxmZXRvUkRtTDNGMjFDcEF6U0F4RjB6MWVvMm9Bc0JMMHdTM1ZZ?=
 =?utf-8?B?L2JlcTN6OXVuYVFiV05rNTZuellvV25zR0JQSlVzRStYNDFOQmIycEl4dWN2?=
 =?utf-8?B?M1JXUS8yTGRkMEs5SEh3ZkY3emgrdWx2S0MyK21PNmY5ZHgzUzh3VUsrOEJN?=
 =?utf-8?B?ZVgxeW81ZitreFpLS0hWWmtmTG9MNjB5SHRYcDJDcGRjelhCcUorOGVzbDFS?=
 =?utf-8?B?dHFsNWJDU3dOb25DQ2ZXcmQvazY5VUw2MldiL3AzRGxOYXNTMk9WNkJ5NnRN?=
 =?utf-8?B?YzBLYXIrVmRuMk0vSHRFbXM3ai9CcTFkQW9vbFd5MjZkWk5ZWkV6M1h4MlFq?=
 =?utf-8?B?d0FyZjZhRXNoL0JxeUZoSzN0eEZhZUxKdndiOVRRR28zejM5dkNJWEJyV25H?=
 =?utf-8?B?TEhqUGZJZnZnaTlESFVadnp6K3VzMUZTT0lUc25YN1BKODM2NUV1OExxb2xQ?=
 =?utf-8?B?dnVjdVBnUnFkV041QklNWmhWRFNnWDZRK1BtTUgrT09GdHAyVTI1R0tUN0JU?=
 =?utf-8?B?ZjRpZUxjRkZYT1lhdWFIVkw2LzhxUVBIVEVVWlZJclhEWGpwOTZncUV2QlVi?=
 =?utf-8?B?QVllU2c0TjdTZVZXd05ubGJUZG14NTdodFQ5eXVxeTY1Nlpjd1E2TmpQZmsx?=
 =?utf-8?B?MXBBenp3V1NtVDdZdnZDa3E5dlRsaktDbm9RUVhhTStMUzhzdThreUw1dG56?=
 =?utf-8?B?UFkzQU03UGc4RTI2RGpNd2VZTWtWa05URVlDNjdpSnhpSURwSVVvbTRYU3lN?=
 =?utf-8?B?S3JHMG13SmdwenJlR0toR2ZoMjFmRzF4VVN1ZkRLS2t6NmhBb0MzaG9sUkZy?=
 =?utf-8?B?eFJPVnZ4MThUektodmhGaTgra09sWXFYVFQ2MVRvWktFQ3ZDdWJmSW1SaU1z?=
 =?utf-8?B?RWRYblFWbDdhb1BwbDJ4bWhONUcxMEQyMVhsS0FTT094TGdvMVlxek5ZMTVC?=
 =?utf-8?B?eXh5SEJVWWxZNHJrQzRoU25maDhsVWRjakVkZTRzVUVqdlNjMFdCeGgwUGJh?=
 =?utf-8?B?bkxhaG1qZnppUzJDV3R1L1ZxVEJwOUszOXNMVVdyR2xOSFNHeHRLOSswbVZ3?=
 =?utf-8?B?RDRjWVRkd3JRNjhtdU12VFNZWGc5Z1ZBNDY0T3VVckQ2TVN4ejRwS055OTFG?=
 =?utf-8?B?cHZEMk5DTVdOczVidGpPYmhIall4c3gwVnVUZFdQUlJWOE1BMUk1MDVHTDdk?=
 =?utf-8?B?SExXM2xLM01vZTBHa0JZdDFhdVlkUkJ2ZGQ2dnpQY1pkaEhRKytQWTNPcm9z?=
 =?utf-8?B?d2dNT2RieTNjL2NYemtxaGczb3k1WmVlTlZaclBEUlNhaVdEMmt0ckFwS2l0?=
 =?utf-8?B?dHk2OTJ2bnJIYTZIUmVVaWt5Q1lkTEEzZkNlQmVGTVNWUmlRNGJDdWxOSHc0?=
 =?utf-8?B?VVlKZTlNbmtleXBuK0x5RFFNYnpzQ1kxcDBQZ3IvNHRWTndqRDFYY3RnPT0=?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a822e4f2-4909-4d8f-d33c-08db402a2eb1
X-MS-Exchange-CrossTenant-AuthSource: PH8PR10MB6290.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Apr 2023 16:30:12.3510
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: +lYUr69FLPlG77dhEwuYR+QizFXrtYHCZ4RgnnntQnpDCM8+aHTE0aS5ithy31fmeYM3iHtG6spCLnoOo5XhP3iEMCpUFyJfPx8HKvlUbP28BjegBxy45oov37HeHurl
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH0PR10MB4842
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.254,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-04-18_11,2023-04-18_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 suspectscore=0 bulkscore=0
 mlxscore=0 mlxlogscore=999 adultscore=0 phishscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2303200000
 definitions=main-2304180138
X-Proofpoint-GUID: PI1ixGzZXCvJ0lryPga5YwPqnafUe8nK
X-Proofpoint-ORIG-GUID: PI1ixGzZXCvJ0lryPga5YwPqnafUe8nK
X-Spam-Status: No, score=-5.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi all,

On 18/04/23 9:30 pm, Shuah Khan wrote:
> On 4/18/23 09:45, Naresh Kamboju wrote:
>> On Tue, 18 Apr 2023 at 21:04, Greg Kroah-Hartman
>> <gregkh@linuxfoundation.org> wrote:
>>>
>>> On Tue, Apr 18, 2023 at 08:38:47PM +0530, Naresh Kamboju wrote:
>>>> On Tue, 18 Apr 2023 at 18:03, Greg Kroah-Hartman
>>>> <gregkh@linuxfoundation.org> wrote:
>>>>>
>>>>> This is the start of the stable review cycle for the 5.10.178 release.
>>>>> There are 124 patches in this series, all will be posted as a response
>>>>> to this one.  If anyone has any issues with these being applied, 
>>>>> please
>>>>> let me know.
>>>>>
>>>>> Responses should be made by Thu, 20 Apr 2023 12:02:44 +0000.
>>>>> Anything received after that time might be too late.
>>>>>
>>>>> The whole patch series can be found in one patch at:
>>>>>          
>>>>> https://www.kernel.org/pub/linux/kernel/v5.x/stable-review/patch-5.10.178-rc1.gz
>>>>> or in the git tree and branch at:
>>>>>          
>>>>> git://git.kernel.org/pub/scm/linux/kernel/git/stable/linux-stable-rc.git linux-5.10.y
>>>>> and the diffstat can be found below.
>>>>>
>>>>> thanks,
>>>>>
>>>>> greg k-h
>>>>
>>>> Following build errors noticed on 5.15 and 5.10.,
>>>>
>>>>
>>>>> Waiman Long <longman@redhat.com>
>>>>>      cgroup/cpuset: Change references of cpuset_mutex to cpuset_rwsem
>>>>
>>>
>>> That's a documentation patch, it can not:
>>
>> Sorry for my mistake in trimming the email at the wrong place.
>>
>> I have pasted down of the email as this suspected patch,
>>
>> cgroup/cpuset: Add cpuset_can_fork() and cpuset_cancel_fork() methods
>> commit eee87853794187f6adbe19533ed79c8b44b36a91 upstream.
>>
>>
>>>> kernel/cgroup/cpuset.c: In function 'cpuset_can_fork':
>>>> kernel/cgroup/cpuset.c:2941:30: error: 'cgroup_mutex' undeclared
>>>> (first use in this function); did you mean 'cgroup_put'?
>>>>   2941 |         lockdep_assert_held(&cgroup_mutex);
>>>
>>> Cause this.
>>>
>>> What arch is failing here?  This builds for x86.
>>
>> Not for me.
>>
>>
> 
> It is failing for me on x86_64 with CONFIG_CGROUPS=y
> and CONFIG_CGROUP_CPUACCT=y
> 

Added some observations on 5.15.y thread:

https://lore.kernel.org/all/bd46521c-a167-2872-fecb-2b0f32855a24@oracle.com/

Thanks,
Harshit

> kernel/cgroup/cpuset.c: In function ‘cpuset_can_fork’:
> kernel/cgroup/cpuset.c:2941:30: error: ‘cgroup_mutex’ undeclared (first 
> use in this function); did you mean ‘cgroup_put’?
>   2941 |         lockdep_assert_held(&cgroup_mutex);
>        |                              ^~~~~~~~~~~~
> ./include/linux/lockdep.h:393:61: note: in definition of macro 
> ‘lockdep_assert_held’
>    393 | #define lockdep_assert_held(l)                  do { (void)(l); 
> } while (0)
>        |                                                             ^
> kernel/cgroup/cpuset.c:2941:30: note: each undeclared identifier is 
> reported only once for each function it appears in
>   2941 |         lockdep_assert_held(&cgroup_mutex);
>        |                              ^~~~~~~~~~~~
> ./include/linux/lockdep.h:393:61: note: in definition of macro 
> ‘lockdep_assert_held’
>    393 | #define lockdep_assert_held(l)                  do { (void)(l); 
> } while (0)
> 
> thanks,
> -- Shuah
> 
