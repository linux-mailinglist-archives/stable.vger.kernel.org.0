Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6192E6ADF31
	for <lists+stable@lfdr.de>; Tue,  7 Mar 2023 13:53:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229772AbjCGMxq (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 7 Mar 2023 07:53:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbjCGMxl (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 7 Mar 2023 07:53:41 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B393190;
        Tue,  7 Mar 2023 04:53:38 -0800 (PST)
Received: from pps.filterd (m0333520.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 327842tg001757;
        Tue, 7 Mar 2023 11:43:53 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=message-id : date :
 subject : to : cc : references : from : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2022-7-12;
 bh=S0nw659Z0cvN7EH86SoYCe9ODVhEBID5V9gloXSeuj4=;
 b=trK+uFnm3oEiGViIyJwMv+fTOLVGIPOo4fSYqtNcsQhVbfUb1pBy+W4uj1dzDUs5fBIe
 FWQjZCATeFtLeWnz9h3fPWGMzvHZDri1Cye2cWIlR5AwfumIaKg/3X3jRF/MG3NP9Dwd
 l3bD2Zs/vivd2dX2Ej5VBfjN4kRyiIHQyxFBx2SPP2+aKTGF1o+REPJGURxW+WDYUyq6
 AQOVpNbG0i7a96KG2/HPnBbxt23+r34yPzMMotwVn7C5N26BnKXILjp7rhwgHONUebF5
 Ht6KwG5G1htitZ3qywE/uOkC8lu4Xd/4+mCOKuxH+jAO7pJVqfFuMS5biPNB1lUjuwdX cA== 
Received: from phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (phxpaimrmta02.appoci.oracle.com [147.154.114.232])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3p415hwakh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 11:43:53 +0000
Received: from pps.filterd (phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com [127.0.0.1])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 327APRn4025353;
        Tue, 7 Mar 2023 11:43:52 GMT
Received: from nam11-bn8-obe.outbound.protection.outlook.com (mail-bn8nam11lp2169.outbound.protection.outlook.com [104.47.58.169])
        by phxpaimrmta02.imrmtpd1.prodappphxaev1.oraclevcn.com (PPS) with ESMTPS id 3p4ttjvd27-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 07 Mar 2023 11:43:52 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=i3OllJeJr/fefXgo3VohisybV0rGKm8urreAs8QcPyyeK0SVVgl1Dth//gnH8eBT1OlRk5G5cj3nJeXm8YAs7G3wTj+0KOtR7FlZ3nwXVkpxaXWJrsjwZMlosSWpCphBCnP2pQN+xt8wNSRlXc3EGTr4LRVL932Nu3psN7BGmP0P6AevYup9fro1Iapu9vRY5aYHBS8kwd47Veoc7eo2i9g7nSRAnffMC8H6bCP3Qj/Ut9XpkAD1wUmLHu5BUgsDkwVtCEqY40H+SE8X4Mesq/F4s+DQpTmyh9h5PKQVBnh4y5Br6IgjBtqu0s8C9Y38hoLQYoPIiiSQaxKo5NNwlw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=S0nw659Z0cvN7EH86SoYCe9ODVhEBID5V9gloXSeuj4=;
 b=RO8rHUBN7Wg4O0NdlOLJ59p4mVx7CzblFkGNkMx8TcYAsv6B51CCm1w2zXDtJRMzk5b29ET40xW9349bodWVqSx0pP0OY5lLLUG4ok9sSuvuTzvETaqZ3QvYTJiiqZ/gCldJXNDdk6BbjYmVjPrzgElam1/OkVCiqqp14JXQfMRqyzdMLmqnvcYT0XbgF8STg1spqeH3TMFQ6Mty8GE4iQ5emhaEF8c+PqZxPbZWheFvuykFodjgZwpMFtI8sPbzHd8U2CcaMxxNy06YetDswjF6dU3EGrf+IbaPRjnwnbZx3+/WTFAkHS/eLAhKUIyxfrradAuf6uTTwrd6pPFQDA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=S0nw659Z0cvN7EH86SoYCe9ODVhEBID5V9gloXSeuj4=;
 b=njNMNf8g9Jwmx4dSSPBDGDGtItsqlY/Xkt3ZWIpEmjUkA/SiPEYTna3W4Z9IkT/h00TBkk1XjOw/i7qqhQ8n62Q+t0zEgccpkzanHZ/eVy9ncTqx1wMYFvzXY/FWQQ3/HiNda71q5W5iJQ5Uurtz8dafNZElNABA79n54cVozXI=
Received: from PH0PR10MB5433.namprd10.prod.outlook.com (2603:10b6:510:e0::9)
 by PH7PR10MB5769.namprd10.prod.outlook.com (2603:10b6:510:125::13) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6156.28; Tue, 7 Mar
 2023 11:43:49 +0000
Received: from PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43]) by PH0PR10MB5433.namprd10.prod.outlook.com
 ([fe80::a0c1:677d:5394:bf43%6]) with mapi id 15.20.6156.029; Tue, 7 Mar 2023
 11:43:49 +0000
Message-ID: <e70bf38e-af6a-dc63-3249-adbf168a1233@oracle.com>
Date:   Tue, 7 Mar 2023 12:43:42 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.2
Subject: Re: [PATCH] docs: add backporting and conflict resolution document
Content-Language: en-US
To:     Bagas Sanjaya <bagasdotme@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>
Cc:     linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, backports@vger.kernel.org,
        Harshit Mogalapalli <harshit.m.mogalapalli@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        "Jason A . Donenfeld" <Jason@zx2c4.com>
References: <20230303162553.17212-1-vegard.nossum@oracle.com>
 <ZAQUkbxQxCanh+9c@debian.me>
From:   Vegard Nossum <vegard.nossum@oracle.com>
In-Reply-To: <ZAQUkbxQxCanh+9c@debian.me>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: PR1P264CA0108.FRAP264.PROD.OUTLOOK.COM
 (2603:10a6:102:2cf::19) To PH0PR10MB5433.namprd10.prod.outlook.com
 (2603:10b6:510:e0::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: PH0PR10MB5433:EE_|PH7PR10MB5769:EE_
X-MS-Office365-Filtering-Correlation-Id: 28ce44d8-0a14-43d8-2dde-08db1f01378b
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: IoPGFmA3e9mZ5W1Y5tcHhRh/LqcEaVJoe36jEdq7C/WuRGB0g0ybNc/8FvcnJSfNYvP/finwbXHfDqNaT5oc/C5WAKlIAHKIZpESE3ucZKthygb7GxF071WIZluSCAR4WuNPcxrLwWn3gy3CNUZSMjxmgYHOqkmbEFZs6W6qaXLjaC8KnbPMS4sdESutjHIDJWA1C3VRt3TZpmr5DAwiBJYdGAUnf2r15iMFQHgEB0GF9jO0Vrxdz008PudyQ2BgWNPauql5ND1wrnyUXNBruzjOWZ1pLt+kXjqGPKnZbz1bKb0RoBl5LB0JWqOGRWlxwDvM/gdnK8m6RAl8mOMrwsKqNbMJgOGgz/E+/f7+dV6mZ9Ls4m/A3x/qbLzn2qACVUbpvJnuDDcU6BOHUOPbwlKgN8hTZ8hC3yOWja2YkaRQtS684ahLQlsI0LJaz6Loy1HxF82AtOMYhkiWjp3GEaF3O9KJTBYuYhJajzD8pciRAGLwhXtqU8HvJqLqedAVjDAUcQA2EX2zI1uyBqFPv8e2vDxTIjQ/bhbEEAKk4Eo/Z5j/tfAEBLNUJQWgXfuCnB5xNPm+FRmYFLXk5oADPlZxUqymr/P2/R+bs+dzcof8gnuFr2VxquNu6V1J6JT/Iko81mJkpJuOEOgeUEX0IzBdzSOILCLJ1/ecVot5L/8LCIJrqlRhJht9yrDeZr08a9jxhQ5Uc4qD4NC1LwC4x2B66lKHvIIIebzarDETNPUAwMOV8pQFWOz3g9L2pCN5
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB5433.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(39860400002)(366004)(376002)(136003)(396003)(346002)(451199018)(86362001)(31696002)(36756003)(66476007)(316002)(41300700001)(66946007)(66556008)(8936002)(44832011)(30864003)(8676002)(5660300002)(110136005)(54906003)(4326008)(2906002)(83380400001)(38100700002)(26005)(6506007)(186003)(6666004)(53546011)(478600001)(6486002)(6512007)(966005)(2616005)(31686004)(66899018)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?aGlNTURUVDE3TWsxTklMZEs4SGxwbjBNcTBTdnNtdDU1QTNyVytrcG85WmRK?=
 =?utf-8?B?dUdJV29GREZIVXJNd0x3OEZJanZxUHdCUFZVQWF1OWl5MENra2h5SmdVc3E5?=
 =?utf-8?B?d0NKbmJiQlB1MU5rYXJocGJBVitxMlRUTE92SDFlWFJSaC9Wd0l4anJZSTZl?=
 =?utf-8?B?SklKTTA2QjJYQjVqRlA1UUovWFdhbVpnUVVCN0NLb09FazBkMnBESkVJbFRO?=
 =?utf-8?B?Q2tPTFdVSUdWWGR5MG1oSXFPMDRUVGM5OU9JVjM4RExpajR1RE0xWjI5YlFS?=
 =?utf-8?B?YnFGOUx5Y1FMTm1TK0E3aUtLWWh5TDFQVS81dzduQzlnQ042RFpXQUxXdGVR?=
 =?utf-8?B?Zk9NcmZZbnBqcVh2K2pBMVZnOFlKNjJHb1NoRGNNSUhNWFI2YitTTlMrNm52?=
 =?utf-8?B?RURhbnFmc3VGTUZ1MTNIZ3pzek4vU2pWcXBVeWJQelc0OGtDNDU2TDZ5c1d0?=
 =?utf-8?B?S09OQjdPbnFnSzA4bWtiU2RmWjQrY3RoQWNqK3MraGIyWG8rYVZ1T3hnd2VJ?=
 =?utf-8?B?WFBGVjgydFJQcGp5dXNBNEZOS1JxZTV4QmdmaFh5NGZRZGpGY3ZHOGJ5ZXdL?=
 =?utf-8?B?TWovL0VER0RESVNZelFmWWhhMXlVL2NsUE9HRGRlZktZcnFOVFpuaFRNOUJM?=
 =?utf-8?B?ckZDcGtqcnNVeXBGcjYydUQrdFVsQnFFRjJrMTV0WlRpVXY1ZTVOSk5uQnlo?=
 =?utf-8?B?NFVoT3VjZmovZm1seGgzQnJnRGwrdEQxRUZjbVE4SjNUQlNmQnFhSWZkWXUr?=
 =?utf-8?B?Y0NjSmNDRXkzdXhHdXVIbW91bkNvblRiNlJQMWNaZ3o4cTdvczJ2UTVIQXVz?=
 =?utf-8?B?TzhWazZDRXQvTDBmUWhrNmZWQSsyeStFalZuOGI4c2g0dStoMGMyUUptalcw?=
 =?utf-8?B?bllFekJsN1JoYzA5Zml0QlhKdTBtSUp3SHZMc3dvOXNoSkpGenhFQ2xkZkhn?=
 =?utf-8?B?TG4xdUZ1UDEyb0FYdlBCVVZld1R3UjV4TFpBUEhxa0lvUVRmYW1pWERCb2xj?=
 =?utf-8?B?b1RDQXMwT0hWbWNCTDV3cEc0RW8rbzIwZm9YNHBCQ1F1NTNrNkRCK2c4ZmNG?=
 =?utf-8?B?Q0p3enhLQ2tuY0g5ZG1nK3R5RUdnMmRYRC9URHNBVXpnZ2NOejYrU2dNYlJH?=
 =?utf-8?B?OEViaURQV1o3UUJPM0lMbS82L1N5QitXbkZUbjMzcXFsV2NKZ1VId0EyNXcz?=
 =?utf-8?B?L3pRdks3cENGdVp3MVZwQVRrckR5R1l5ZS9SWk9CY2h1YW5acWM5amNmbldE?=
 =?utf-8?B?bmVWbzNIQS9MSWRVNFB6V0xjQjI2YlNlTklNcVZISkZmQjlQQXVWWFZrSlNh?=
 =?utf-8?B?cUVmY1BSTjNzMnpnZTE1OEt4SUt0UHNlSVgza215QTliMnkwcVg2R011RzI5?=
 =?utf-8?B?Uy9USHJsZlJMWWxnVVhGZkx1K2xxR1JpYXdXTDVTcW11QlZ4MkNxeW4yeTMw?=
 =?utf-8?B?MU5DV0l0RUxpbHBwbUQrR084MnFrdkF5djl5M0UrK0xHbEk5UGVwcUtNZUJ1?=
 =?utf-8?B?RkVVeC80SHdIOVRCVDU1bVFzYkw3R2RiWElpSVovT0ZSWXlOSDVSUmdYdmN1?=
 =?utf-8?B?WWtLSzdZL1hjbDR2NU9FS1ZPa1FDd3hZRGgxTUEvY2p6Y0RSb0tVRjlnUy9w?=
 =?utf-8?B?eTRIa1BIMTc1M0ZESmhqUnN4czBCckVIcGFHd2xIUlgzNmc5Z2E5MnlScFpz?=
 =?utf-8?B?UGRDQ0hpd3pXNnRkNVQycFhOcFRQNUJRbEM0V1htMm84d3NoRVNNYXVJeUFo?=
 =?utf-8?B?YlFhZkJnaVp6b0JpTDI5Wk16WlJKNDBSSTUrSEt0K2pJMVlQbUkvbCtsWS90?=
 =?utf-8?B?NEF6N2ExdjJhK0hyb0RraEVhSE5HN2Zvbkg5SFlxNjJxeG5Idm5ROHhQZWFY?=
 =?utf-8?B?QVVCY2VQZVpwSGo2WmlpS0cvS3ZDTGpmYjA0VXVPMkdhY1FmZlAybXdDYUxu?=
 =?utf-8?B?RXlyVFZuYmtNTEM2SlNkZFQveGJqWkp6T1pmOTBYeFcyNlVRRkxGZTBlUnlV?=
 =?utf-8?B?MjR2UTdicDlMQ25iaVdHaFVQTnZhNHZJQ1NqZklQV1hxbTBwT2xPeEU2TjNz?=
 =?utf-8?B?TUdqSFoxT1Z4ZGluOUM1WmFmenpOSmx1Sm01cHNXWHhJOWxPZElWTXFyK3ZL?=
 =?utf-8?B?V3RNbzAwWk9JNE5abjM2SjRaYWZQQmtpSGpqQ0hCZGtRL29lN1Z2eEUyZXRF?=
 =?utf-8?B?Y0E9PQ==?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?N0lnYU9tQW5oMGsyeEh1SEpUSjlDaEFzQ1ZxUTNsL1Yyd0xPaTNGL3Z1MHlj?=
 =?utf-8?B?RWxTY3k4MVlHdnNqNWYvTkoreFZyT2R1NGhONi9RVndFMVorK3p0SzFrTzNN?=
 =?utf-8?B?WmtwMW9QZEJFV081Qi9yQXZZYlN2YVV1d2dsa3NSV0RLK2FoY20yaWZZSi9l?=
 =?utf-8?B?bGdsZDFNTlN1NGx6YmwwY3dVdllESU5DR1dGUFdtSGd5cEhVRFBIMU9tYksw?=
 =?utf-8?B?aWVqWlJidWdFeTdJWVNLbHdhUWU4Yys2TW1xYXBtMFZHZlhqVjVPbXluOWRD?=
 =?utf-8?B?Rys1d2NRVlR4cEVacmd1SS83K0RLTWJDUXk4NUpCeEtybEdkTzRaSzROejBN?=
 =?utf-8?B?ZHFudytxWFc4SytCc2RIeGxxUDJrdTR0S2dlL1NCVTV6ZmtTS3JTRkdrbXJx?=
 =?utf-8?B?YVR0V29EWkY3YWZ3VFpySnpFb1BVczFYZ0krd0xQcFlZdmoxOUM5NHRkL3dP?=
 =?utf-8?B?c0hmemxSZXA5NEthZVlIQTBZQjRBU1ZSVGlpRUhyQ1NJVWxrRWZmTXVRd09u?=
 =?utf-8?B?TW1rWngyUmV6cHFoakhWK0RhT2xhVjVzd2dNWnJmbSs1NVBiY2FqVk1NSjZ2?=
 =?utf-8?B?TWRLVVlDN2M0N2cyM3duYU5GS0FDQWs1SVlveVNlNVR1Nm9YbGNvSjhIZUI5?=
 =?utf-8?B?ZTVkWER3cVEzM2t5dXdnM01Dczd3RmRlZXNrVlVZRHpOaUZSRDdvRmpjaFpE?=
 =?utf-8?B?cVRzUWNaUW1VcWNISE84Q3VqM1F0Qjg0VmdxUlB6V2k1Vk43NGFzY0t4L29V?=
 =?utf-8?B?cXlFNkhPL3VhaXJrN0NsTWx4QzAyUjJxejIwbDFXcjhOY1BqQzdEUWdHN3Ew?=
 =?utf-8?B?b0N3eFhKRU1teW5sWG9CRU1DTThOVHRyaFV2cFNCYzlNamp0QThkTHdkVi9Q?=
 =?utf-8?B?Q2Z0bnZLWXhXVkFwckQ4bVZQNlJhdkx4dUxrblNjWDRFNFVoa0RWVnI4bWxr?=
 =?utf-8?B?cDJLZG9aQzV1czJQYlRkNzMrcVJ0QnZnZVEwUkMvaUtRUGROcVlWa3p1Yjla?=
 =?utf-8?B?MGU2NC9tQ1JpbWNuSjk1aFh4OTRiTXJGa1IrdVl0WGtnNE9EVlNadWRyKzFO?=
 =?utf-8?B?bTZCRTBOM1RMUkJjN29WcnUyQkpwVGIzeE5qQVVnRlV1cEJTcDVGWGczSjJL?=
 =?utf-8?B?QlBsNGlNQ1djM05QVVhSREk1V01pWmk2Q1cxN1N2TkgxeUFkVEE4QytRSTBF?=
 =?utf-8?B?QlpTWHI3TlVTT2RYM25kd0c3ZDBPRldzQVlNRlVhRXVacVlUalJsemdnamFl?=
 =?utf-8?Q?LVcFlgS/4wJ1hSe?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 28ce44d8-0a14-43d8-2dde-08db1f01378b
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB5433.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 07 Mar 2023 11:43:49.2696
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: jXvVGMwoLDi2NsgEuANAK3DBK3Pb+zTXCulE8UC3+WFw8Jd7fGgwLhTHu8ScfbnCOT8zy2kzKs6k49uxXsRy97bRHURCTj7Bfh5mOjvOVQ0=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH7PR10MB5769
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.942,Hydra:6.0.573,FMLib:17.11.170.22
 definitions=2023-03-07_06,2023-03-07_01,2023-02-09_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 phishscore=0 malwarescore=0
 mlxlogscore=999 bulkscore=0 mlxscore=0 adultscore=0 suspectscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2212070000
 definitions=main-2303070105
X-Proofpoint-GUID: BS2uXS8jb6Uhqocrgw1b198A9UBvnfvn
X-Proofpoint-ORIG-GUID: BS2uXS8jb6Uhqocrgw1b198A9UBvnfvn
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org


On 3/5/23 05:03, Bagas Sanjaya wrote:
> On Fri, Mar 03, 2023 at 05:25:53PM +0100, Vegard Nossum wrote:
>> +It is strongly recommended to instead find an appropriate base version
>> +where the patch applies cleanly and *then* cherry-pick it over to your
>> +destination tree, as this will make git output conflict markers and let
>> +you resolve conflicts with the help of git and any other conflict
>> +resolution tools you might prefer to use.
>> +
>> +It's generally better to use the exact same base as the one the patch
>> +was generated from, but it doesn't really matter that much as long as it
>> +applies cleanly and isn't too far from the original base. The only
>> +problem with applying the patch to the "wrong" base is that it may pull
>> +in more unrelated changes in the context of the diff when cherry-picking
>> +it to the older branch.
>> +
>> +If you are using
>> +`b4 <https://people.kernel.org/monsieuricon/introducing-b4-and-patch-attestation>`__
>> +and you are applying the patch directly from an email, you can use
>> +``b4 am`` with the options ``-g``/``--guess-base`` and
>> +``-3``/``--prep-3way`` to do some of this automatically (see `this
>> +presentation <https://youtu.be/mF10hgVIx9o?t=2996>`__ for more
>> +information). However, the rest of this article will assume that you are
>> +doing a plain ``git cherry-pick``.
> 
> Above are from applier's perspective (maintainers and/or developers
> doing the backport). For patch submitter, don't forget to pass
> --base=<base-commit> to git-format-patch(1) so that the applier can know
> the base commit of the patch to be applied. For patches intended for
> mainline submission, the applier could create a temporary branch based on
> specified base commit (as described above), apply the patch, and rebase
> to latest appropriate subsystem tree (and resolve conflicts if any).
> Others could instead directly apply the patch on top of subsystem tree.

This whole document is meant for the developer doing the backport.

git-format-patch --base= is already covered here:

https://docs.kernel.org/process/submitting-patches.html#providing-base-tree-information

I don't think we need to repeat it in this document.

>> +
>> +Once you have the patch in git, you can go ahead and cherry-pick it into
>> +your source tree. Don't forget to cherry-pick with ``-x`` if you want a
>> +written record of where the patch came from!
> 
> "In most cases, you will likely want to cherry-pick with ``-x`` option
> to record upstream commit in the resulting backport commit description,
> which looks like::
> 
>      (cherry picked from commit <upstream commit>)
> 
> However, for backporting to stable, you need to edit the description
> above to either::
> 
>      commit <upstream commit> upstream
> 
> or
>      [ Upstream commit <upstream commit> ]
> 
> "

Good point -- the original blog post where this came from was meant to
be more general than just stable backports, but this document in
particular is partly also meant to aid stable contributors we might as
well include it.

>> +For backports, what likely happened was that your older branch is
>> +missing a patch compared to the branch you are backporting from --
>> +however, it is also possible that your older branch has some commit that
>> +doesn't exist in the newer branch. In any case, the result is a conflict
>> +that needs to be resolved.
> 
> Another conflict culprit that there are non-prerequisite commits that
> change the context line.

I think that's already covered by "missing a patch", or at least that
was my intention. I guess we can change it to something like:

+For backports, what likely happened was that the branch you are
+backporting from contains patches not in the branch you are backporting
+to. However, it is also possible that your older branch has some commit
+that doesn't exist in the newer branch. In any case, the result is a
+conflict that needs to be resolved.

I'll fiddle a bit more with the exact phrasing.

>> +git log
>> +^^^^^^^
>> +
>> +A good first step is to look at ``git log`` for the file that has the
>> +conflict -- this is usually sufficient when there aren't a lot of
>> +patches to the file, but may get confusing if the file is big and
>> +frequently patched. You should run ``git log`` on the range of commits
>> +between your currently checked-out branch (``HEAD``) and the parent of
>> +the patch you are picking (``COMMIT``), i.e.::
>> +
>> +    git log HEAD..COMMIT^ -- PATH
> 
> HEAD and <commit> swapped, giving empty log. The correct way is:
> 
> ```
> git log <commit>^..HEAD -- <path>
> ```

Hrrm, I've double checked this and I think the original text is correct.

HEAD..<commit>^ gives you commits reachable from <commit>^ (parent of
the commit we are backporting), excluding all commits that are reachable
from HEAD (the branch we are backporting to).

<commit>^..HEAD, on the other hand, would give you commits reachable
from HEAD excluding all commits that are reachable from the parent of
the commit we are backporting.

With a diagram like this:

o--o--x--y--<commit>
     \
      \--u--v--HEAD

HEAD..<commit>^ would give you x and y while
<commit>^..HEAD would give you u and v.

I agree conflicts could come from either branch, but when backporting it
is more likely that they come from the old branch (so x/y above).

<commit>^...HEAD (with 3 dots) would give commits from either/both, but
then it's harder to tell whether you need to apply it or revert it, so
it's probably better to check the ranges separately.

> Note that for placeholder arguments, I'd like to write the
> placeholder name inside chevrons, like above (git manpage style).

Agreed, will update.

>> +It might be a good idea to ``git show`` these commits and see if they
> ... to show these commits with ``git show <commit>`` ...

Fixed.

>> +Prerequisite vs. incidental patches
>> +^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
>> +
>> +Having found the patch that caused the conflict, you need to determine
>> +whether it is a prerequisite for the patch you are backporting or
>> +whether it is just incidental and can be skipped. An incidental patch
>> +would be one that touches the same code as the patch you are
>> +backporting, but does not change the semantics of the code in any
>> +material way. For example, a whitespace cleanup patch is completely
>> +incidental -- likewise, a patch that simply renames a function or a
>> +variable would be incidental as well. On the other hand, if the function
>> +being changed does not even exist in your current branch then this would
>> +not be incidental at all and you need to carefully consider whether the
>> +patch adding the function should be cherry-picked first.
>> +
>> +If you find that there is a necessary prerequisite patch, then you need
>> +to stop and cherry-pick that instead. If you've already resolved some
>> +conflicts in a different file and don't want to do it again, you can
>> +create a temporary copy of that file.
>> +
>> +To abort the current cherry-pick, go ahead and run
>> +``git cherry-pick --abort``, then restart the cherry-picking process
>> +with the commit ID of the prerequisite patch instead.
> 
> IMO, finding prerequisite commits can be done without attempting to
> cherry-pick the desired commit first.

Yeah, of course. I'm in two minds about mentioning this, though. On the
one hand, yes, it would make sense to look at prerequisites before even
starting.

On the other hand, a very common scenario (and the one this document is
using as an example) is that you've attempted a cherry-pick and git gave
you a conflict.

In the end, I think it's much more common that you're in the middle of a
cherry-pick and you need to know what to do to get back to a
non-conflicting state without actually resolving the conflict.

>> +Sometimes the right thing to do will be to also backport the patch that
>> +did the rename, but that's definitely not the most common case. Instead,
>> +what you can do is to temporarily rename the file in the branch you're
>> +backporting to (using ``git mv`` and committing the result), restart the
>> +attempt to cherry-pick the patch, rename the file back (``git mv`` and
>> +committing again), and finally squash the result using ``git rebase -i``
>> +(`tutorial <https://medium.com/@slamflipstrom/a-beginners-guide-to-squashing-commits-with-git-rebase-8185cf6e62ec>`__)
>> +so it appears as a single commit when you are done.
> 
> I'm kinda confused with above. Did you mean that after renaming file, I
> have to abort cherry-picking (``git cherry-pick --abort``) first and
> then redo cherry-picking?

Yes, the idea is that instead of trying to resolve it as a conflict, you
rename the file first, do a (clean) cherry-pick, and then rename it back.

What caused the confusion, specifically?

>> +Build testing
>> +~~~~~~~~~~~~~
>> +
>> +We won't cover runtime testing here, but it can be a good idea to build
> Runtime testing is described in the next section.
>> +just the files touched by the patch as a quick sanity check. For the
>> +Linux kernel you can build single files like this, assuming you have the
>> +``.config`` and build environment set up correctly::
>> +
>> +    make path/to/file.o
>> +
>> +Note that this won't discover linker errors, so you should still do a
>> +full build after verifying that the single file compiles. By compiling
>> +the single file first you can avoid having to wait for a full build *in
>> +case* there are compiler errors in any of the files you've changed.
>> +
> 
> plain ``make``?

Yes, but I don't think we need to spell that out as it's the common case
(in other words, it is presupposed that you know this).

>> +One concrete example of this was where a patch to the system call entry
>> +code saved/restored a register and a later patch made use of the saved
>> +register somewhere in the middle -- since there was no conflict, one
>> +could backport the second patch and believe that everything was fine,
>> +but in fact the code was now scribbling over an unsaved register.
> 
> Did you mean the later patch is the backported syscall patch?

Yes. I'll fiddle a bit with this paragraph to make it clearer.

>> +
>> +Although the vast majority of errors will be caught during compilation
>> +or by superficially exercising the code, the only way to *really* verify
>> +a backport is to review the final patch with the same level of scrutiny
>> +as you would (or should) give to any other patch. Having unit tests and
> "... patches intended for mainline."
> 
>> +The above shows roughly the idealized process of backporting a patch.
>> +For a more concrete example, see this video tutorial where two patches
>> +are backported from mainline to stable:
>> +`Backporting Linux Kernel patches <https://youtu.be/sBR7R1V2FeA>`__
> 
> For the external link targets, I'd like to separate them from
> corresponding link texts (see
> https://www.sphinx-doc.org/en/master/usage/restructuredtext/basics.html#external-links
> for details).

We can probably do that, but it doesn't seem to be used much in existing
kernel documentation, I find no existing instances of it:

$ git grep '\.\._.*: http' Documentation/
$

I know that lots of people really prefer to minimize the amount of
markup in these files (as they consume them in source form), so I'd
really like an ack from others before doing this.

Thanks for the review/comments! I'll give other people a chance to look
it over before sending out a v2.


Vegard
