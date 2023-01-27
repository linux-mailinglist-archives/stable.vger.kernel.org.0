Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 586C767E696
	for <lists+stable@lfdr.de>; Fri, 27 Jan 2023 14:26:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233168AbjA0N0T (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 27 Jan 2023 08:26:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43682 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233005AbjA0N0S (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 27 Jan 2023 08:26:18 -0500
Received: from mx0b-00069f02.pphosted.com (mx0b-00069f02.pphosted.com [205.220.177.32])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00ECD8016A;
        Fri, 27 Jan 2023 05:26:16 -0800 (PST)
Received: from pps.filterd (m0246630.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.17.1.19/8.17.1.19) with ESMTP id 30R9St48031452;
        Fri, 27 Jan 2023 13:25:49 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2022-7-12;
 bh=Bk8Ozpz0dJmxyS6qaYiQNH7s7mk/1HPIFZ8VW5749OM=;
 b=jvhPwGFCwHOVClrdvg+PjiHZtn4BfDo27OR1Ez6Nac+Ur8JQUSlmXaIerbBgmAFCqcwd
 9+LeoDv+CX4B5VLhis4kMe4DW0E5H70dOuTgjRP1kSRYKSD/8Hj7W3uAPr+bLJnGYMpy
 V/82tap+8j48/Ot4J1w9uqm6wasqT20ChuemRaolMOYMhcGz4mlYMW3HdvJIaOTKiMNp
 O37+XJmgReOodR6lVGM/GMHSoiV00zQlFFG8klmqEr9G2Lp3DOHjEDbZVFkzA495BZ9u
 7om9odLOyMqJABgcopSlST/MvuYSsLB4NDbNI/YMy41Y/OV8SB+TraA9HxZFK9bR4TSW dA== 
Received: from iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (iadpaimrmta01.appoci.oracle.com [130.35.100.223])
        by mx0b-00069f02.pphosted.com (PPS) with ESMTPS id 3n86fcmsfh-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 13:25:48 +0000
Received: from pps.filterd (iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com [127.0.0.1])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (8.17.1.5/8.17.1.5) with ESMTP id 30RBBAak024315;
        Fri, 27 Jan 2023 13:25:48 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by iadpaimrmta01.imrmtpd1.prodappiadaev1.oraclevcn.com (PPS) with ESMTPS id 3n86gfjpq7-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 27 Jan 2023 13:25:48 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BK109lUU1jepKUwpeaBdXNzjdRd5mShFK0rRAOHVOu+glfeKiI41dUaZrwb0jV4LTaSUBBtRTzq8NrcsPMYjbtogmse5XUdte7MxzJWPnlnVEiDJ1QBUf/2L42lmLcT2lcOBSrhu1tkDLEMgUABKGcwfELtG/yQMpvv5Gpe6/jMIA3jRjxaaqR0u1gZLQVsPIsiIBjdqQgHBmdw22afy+KHGg2QxI7A76f5VW0I2Ex9YIFGkxKXL8ZyhKYh7eooNkwa3Xo/26Wa6A0f+agDludNgqCDSRVjFaD6qv98RcOyQCRumX2xBPy5L4orXlXt0ticmzMukYQv6eHAxIpKK8g==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=Bk8Ozpz0dJmxyS6qaYiQNH7s7mk/1HPIFZ8VW5749OM=;
 b=MKLExGE5s0kdGvHpmkY4eH7cdp4oGtk4y5UnUYT1CIiwjgGZkx9/PKXXLU1TxfCvj24oGiUPm3uSGyNFG2/fLg5a6Y7HHd2c+KAAYYi2a592w6FOaTcVVZspcsWyAHBmpOQWVExY+SfuOybTxArE0zKTjeeD8Ua0BWUrKhBo2Ot4vMymU1TbEdvpcqxz1YWM8hRFtPg4jqO6erH3UO2iZcuTf56zy4tkODa+yCuEo8Ea4Lu/ZZKdc6OIAwuQvmuQ8q6zPfIe7kUqOvhBih/vlfz19wXzKLU+MZKgeB2cq8JsdmJWg34rXMrWQDJ5ysQ9RWardh4XtxQcvGdvdK1IZw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=Bk8Ozpz0dJmxyS6qaYiQNH7s7mk/1HPIFZ8VW5749OM=;
 b=h8DGcuOOfSayzf9nh57GK1PLriC5DTO3PRtVrq0HY3OeTrWS0fs26H6B2Y1AZStWnCeEKaGpRBSEekNORqb32hzjSrXJZ6/mXuBzZ9YGxYelaveg1p1CWrwxzGLq1DWrhgacGgg1SuULhcScRLfqqqrroFTTNZCYL6YHLdRWDvE=
Received: from BY5PR10MB3794.namprd10.prod.outlook.com (2603:10b6:a03:1b2::30)
 by BLAPR10MB4899.namprd10.prod.outlook.com (2603:10b6:208:323::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6064.10; Fri, 27 Jan
 2023 13:25:45 +0000
Received: from BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d]) by BY5PR10MB3794.namprd10.prod.outlook.com
 ([fe80::f37e:ad45:7d9e:d84d%6]) with mapi id 15.20.6043.022; Fri, 27 Jan 2023
 13:25:45 +0000
Date:   Fri, 27 Jan 2023 07:25:40 -0600
From:   Tom Saeger <tom.saeger@oracle.com>
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Naresh Kamboju <naresh.kamboju@linaro.org>,
        John Paul Adrian Glaubitz <glaubitz@physik.fu-berlin.de>,
        Rich Felker <dalias@libc.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Nathan Chancellor <nathan@kernel.org>,
        Dennis Gilmore <dennis@ausil.us>,
        Palmer Dabbelt <palmer@rivosinc.com>,
        Arnd Bergmann <arnd@arndb.de>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org
Subject: Re: [PATCH 5.4 fix build id for arm64 6/6] sh: define
 RUNTIME_DISCARD_EXIT
Message-ID: <20230127132540.agmyuzg64wlcwglo@oracle.com>
References: <cover.1674588616.git.tom.saeger@oracle.com>
 <7301d95edaf5bd0926bc93a67cb0cc1256549c95.1674588616.git.tom.saeger@oracle.com>
 <Y9N9Ux4asZRE25zC@kroah.com>
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <Y9N9Ux4asZRE25zC@kroah.com>
X-ClientProxiedBy: SN7P222CA0005.NAMP222.PROD.OUTLOOK.COM
 (2603:10b6:806:124::22) To BY5PR10MB3794.namprd10.prod.outlook.com
 (2603:10b6:a03:1b2::30)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BY5PR10MB3794:EE_|BLAPR10MB4899:EE_
X-MS-Office365-Filtering-Correlation-Id: 9a15c603-d730-4cae-fb74-08db0069feec
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: yAX6QL+xkIEu+F0HdUD9Dk4xpyAXwnMgPcp9NtkFkzlWAbM7L9wcdRuXeBdCEOs6LZ9Gq+0sf1GOeAMR9RmZaQawAGw/OorQuezEfufv+MBgUcnzPFGWdLPHFLZoKBpzZZGAdzwW6eMThPO63EGN+3iUAgs84yFOXpleojlSMhhfDbXMtR5KujzalBUffhQzEPGemzWtg4tJfnIvRPVz3dqqZd4whLFOkTzqfy5TWLi6Wxha1k6+c4ntkRZcR8UVbmuknlKYonul4WIrXQbGklUh87GmCprHtHwYjcf3MJu9/KNV+bqYZWe6uWHreTKfm7BN17pOD30/PWMvR75hE+hulJdRIS240bnfOckgPZxaq2uHcMegvvDkoaTahLNhKe+DF+6FtbueraM4j785GTJ9kyj/GcsrSK4ew8LwbVAd1iO3NrZxBxJ+s9j4y5vuSZtsiMyMiVZcUXCr7X7UrTnjHUjofm6l5B3XKp53Bw3EvWbJZz0U/BldVgI7qkYwhYeZW5HJcAP9sp47/2esxlrQoMDe2TV5AMFj7RjzSwZ1KlXZ5Tf8ft+oVqbSuQE1fOMJvu9L2YmXkze1asisgeQ6T/7FtYw386YAJ4LXunH+t3VCNSSMX2UfT2S5r0X9fvILC2kChN8YOQVWugLCDk9fBQgMI2jKvaItDEXDokREEX80pVOrbhYxr+qxKxawVHD7k3Br3X9L0jC++Emykw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BY5PR10MB3794.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230025)(366004)(136003)(39860400002)(346002)(396003)(376002)(451199018)(2906002)(44832011)(7416002)(36756003)(54906003)(6666004)(966005)(26005)(6506007)(6512007)(1076003)(6486002)(478600001)(66946007)(2616005)(66556008)(186003)(86362001)(66476007)(8676002)(316002)(8936002)(6916009)(41300700001)(4326008)(5660300002)(38100700002)(66899018);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?SE9mWHpFc2RDWFV3OGlMRHRjeUkzUk9mRTJ2OXZrL3BNanUrM2FkZlZLYmc3?=
 =?utf-8?B?eW8ySVZvdjhKQVFaVkVUd1JENjdRVWJCZGp5THo4UnR3T3BlWXMvdWVwTXB6?=
 =?utf-8?B?OWpEdnBrOENMdUFYQldkSXh1YW01cEJlUWlBUlVlN3VyMkZDWGpoT3BsQXJv?=
 =?utf-8?B?b1dYK2pXdWd4ZSt0Z21iUkhYTGV2czFzaTJYbE96TzJmMmhFV2psYXNockt1?=
 =?utf-8?B?OVN3WXEyOU5pa2ZrQXRieUkxY29LZjZPRXVoN0xVb2ljaDhTaHB1MXFtWTFv?=
 =?utf-8?B?ODNxTEVjOVFUQnNHSzhROU0zbmtnaVcxc3QxZ0FPUTV4OEhDNmZzUlpDU0ts?=
 =?utf-8?B?MXZOSzhaZ2REWkJKcnRtVXNmYU9KbUNDd0hnWlNMeDJjbVdJM0V2Sk9uZUg1?=
 =?utf-8?B?VE5UWWZzb2NGWmJ2K2VaL0J5QTNDcnVMajR4L1FFT3NTNDJvWGRkK3BwUGVU?=
 =?utf-8?B?NkpHWitUbkJoZE9xa25RdWY5YXBhZlU5VkdkQmRHQTlVeGp2YzIvamJ1eGdE?=
 =?utf-8?B?UUZ5cGs5QjRveHdPc1J4Wm9SMG93OHEvMmlSNENaQjlqSTQ1QklYNXNHcFIr?=
 =?utf-8?B?cC8yb3JMWjVYdUlrNXQwdmJaWjZGVEh4SzdmbytxNG0vem9Cemt1dWJIMTZS?=
 =?utf-8?B?Q2o2WUd6UkllcTlqNWd0MEJjU1IvZHFVRDlnNEZwMkNEY202UlhpUFVRWnE5?=
 =?utf-8?B?WncvMjJpbXQrbDM0c2ZQQVlXR2F0VGxQVThTUC9qSnBnb2thTG5BdFFEYWEy?=
 =?utf-8?B?V0RRVEZNREVNVkdZR1pTLy9EeTFaZDdqREJibExEU20xVHp0dERsaEdMZ0h5?=
 =?utf-8?B?ejdwL2xKRmpUWWQzd2N5TlltbnRWR1NXK2RBazJVaThKdGcwaWt5SWMyQjB1?=
 =?utf-8?B?VWZlajI1WHYycXZkd3I0d0FuYktRRHBadENjTHFuaENsWXdZUy9qY042ZmJG?=
 =?utf-8?B?QTlYUGtmNkNCQXdiUnVJbGlCaElRckZkV0pHMXdjWitwS09XcytoaFNIdTFV?=
 =?utf-8?B?RENSdkNDa2t2QzJGQjlLSjNndjBES1pBQ21hZnhNb0J1SFZ0M1M4NUptb2la?=
 =?utf-8?B?TUtzejR4QjBWUk9MTTNZa29HMUFtRTQ5b25hY1hQNUtoUHhKUU52REV0Tndy?=
 =?utf-8?B?anFNUis1L2dsZlYyRlZWSzhWZDJSMHhpTHFPMkE4TjJkTDJKZXR3Y3JIVHNt?=
 =?utf-8?B?VWREdEJwZ1hrNVpUZDZ3aHdMQjVGdlFCNWxyZ3czMHAxRlhvSHdyMGQzMzF2?=
 =?utf-8?B?YkVwR3hUNlNNWm82SWxESHpqZzEyUis5elhkckh5QnRWUEtmendJalUrVzk3?=
 =?utf-8?B?WnBoR0V3MmtobHdmM2c0SDdSNlRYNCs0YTd5S2xXSDlUdFZPaEkxM0NreVNN?=
 =?utf-8?B?Qi8zSXVCMmJZMVBacEVEY1NXd3JSeVk3NDFHZWZRVVg0TExzMmFERThqSDBr?=
 =?utf-8?B?Zis2RkptMGI1RFdmUEpzYWovS3BGY0d4TVdjUTZHa3h3SUNVMUVwcWUzMzB1?=
 =?utf-8?B?dHM0VWt0L3daV3RyMk5jL1NmWlZXQkpGUHQ0QThaTytTVlBwaVJLbFlRRHdQ?=
 =?utf-8?B?elg1V3FCMUc3MWZBNFRPcEMwcXA5MzhVbmd4ZEdNTVZOWDFySkZLSDdYWmtu?=
 =?utf-8?B?cFVhc0hKTlpCN1ZzNWJ6dGRIYzk2MDlGa2haMlBRd0c0dE9uenBYc0FpVFdv?=
 =?utf-8?B?LzRoS1pjSjNGWjhtZmMzUE9BS2xOTjVzL2RpN2tlSjc3czZDTEI2TzREM3py?=
 =?utf-8?B?L1JIT29tODVHSmU3VnpJaFJCZUIrRmFscDk1WlB5MkhQQWgxaDB1Q0hWd04r?=
 =?utf-8?B?ZDZobWZkdE04MWFWWk41OEFYSUo3SzhYWnlKZUlDRXNtSTdMV3RWanRueHRm?=
 =?utf-8?B?dUlKSHdCakF1dXpsWmdoaEUreUp0Tzg3TlNEZ0FTcVdXdDBqd2ZBNXVJdGta?=
 =?utf-8?B?QmhjR3F5VFd2dFVtOTNPWjF0SlVEdHhRZDVaKy9TT2RnYnM3OXNJUm9QVktQ?=
 =?utf-8?B?VXZ3elBHaEMzUjd5a1R3ZlFSSVNEcWlQaFBZVS9WZzVuOHVtbHpkUllsUExF?=
 =?utf-8?B?RDB3VHpHR1B4MG80N2MvanhSSlovYnIzSmFzQkxKVUF0NS9BZEhuSWQyd2JO?=
 =?utf-8?Q?MPqhSlr3a5j4g5wObKGpPnGli?=
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?utf-8?B?OWVBN1pvY1JISlpZRzdWWGtseWl6STltZVpyRkJtVlpUTG1ITWs0b1h2TExu?=
 =?utf-8?B?TXF1bFVzbEoxWXJuTVJoM3hzNTJmMkdjdVliY2xLTVpzUVVIaE5nZnhQbkVD?=
 =?utf-8?B?ME1ZdUNJT0h0QW1BRHd5aUt2ZllQejVoeDh0L3JDbEFHOUZVT0tBc2ZnQXow?=
 =?utf-8?B?NDdVRjVWQTMrdDkwc25pK3hNRCtUbzV6OHRFNnE5WE1VcWdBd2lHV1VSeFQ4?=
 =?utf-8?B?dVhXekpqVTd2R1duTnM4MGlxQ1RBU1l6ZnFsMzZuRjZnNHl3SGFjdXpZQnEx?=
 =?utf-8?B?OWpCMUc3c0FVU0NsaUY2RWRRVGE2Mk8xVkdiaUM5Sm00eXFVcXhQTDRoT29W?=
 =?utf-8?B?R2h4RkpiL24xSmtxdWFkUkl6TnNWMWVIMlA3d1JHUkNKSkxGRHRXMEVNQnha?=
 =?utf-8?B?NU9Nc0FwQmhEQzVHZ1FXY2htM2pvb2RybnIrcVZKODZJTUZzcXBVK0VkMk9X?=
 =?utf-8?B?eWdsQXVlUi9oWmQycnpMRXJFeU1TUlp0RkNlQ21ha3l4Tk9YYm8zdnVaQkVO?=
 =?utf-8?B?NW9yOUIweVVFd0lhRVJvMFVzL0Q5RVlxQWNCdmRNSTdiMlVCbzd1eUNuaTRy?=
 =?utf-8?B?SUZoK1ZNMzJpbXFoaHprTnRkK1hER3NURGk5RlFCRXpsZXAwTXdpMWdiYkRF?=
 =?utf-8?B?d1Z3VFk3ajE0UFFuUVRzVnE2VFFWdjN3emMxYUdwVUFESUxjRnorbWJaMmZ2?=
 =?utf-8?B?WnliYjdxNWF6ejJuanBDUmc1aW1GYVVyT0Z1RDJwcTY2VnU3eVk3U1h0R3Bo?=
 =?utf-8?B?WnFlalZwQW5aeHRyYi95Q2ZvQysydnZDY2ZFb2pQSzNvL0RTMnBxVXQzNW5Z?=
 =?utf-8?B?ZnA2U29Yc08rd0tOUjd2eTJYS1VGL0crUmxzeExta3RoQ2dncDg1cEVWUUc4?=
 =?utf-8?B?cDFMUDFJQUNSeVNhaW5GOWQrbUlQWG55YmRja1ZxeEVFQVo3bVEyTWt0dkx5?=
 =?utf-8?B?eG9BNHJ6cTd2TGFML2F4RTFPMEFsUmd1Y2h2WnJsbEk1YnorZDhIa0lzcndH?=
 =?utf-8?B?TUhOdFV3OGxVN2F3d2RYV1pJQ1BweERsTWtUQ0VZeStDajQzc0Q4Mmk5ZGEx?=
 =?utf-8?B?NlU0dEpaV01CLzM0ckR5VkR0TmJHcEkzd0tUZkc5cnpSeS9zWTEwK2d6N0tE?=
 =?utf-8?B?V2ZlNFNkdUJWaFFacC9mWjl6a0VvV0tDNHo0YmRjVlB5ZUduYkhuQVgvclJt?=
 =?utf-8?B?VER3SFpWVzRqNThNVXB6V0pZTHpZUlRoVXltQlVZbkZqQVRWYS95cW5RTGlZ?=
 =?utf-8?B?VFc3T2J2bmF3MFpBdHJIYjBNTHpsSFVyUlMzMkpMK0R0ZzJwM2xOSXJZZmdT?=
 =?utf-8?B?dXU4Rm9vTU9YaSsvcjFnT2w4cWM4K2o0QnlROTdoeHkxa3ZNOGxpMWQ0WmpS?=
 =?utf-8?B?Y0JLenpIbE9QUmc9PQ==?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 9a15c603-d730-4cae-fb74-08db0069feec
X-MS-Exchange-CrossTenant-AuthSource: BY5PR10MB3794.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 27 Jan 2023 13:25:45.5629
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: Rdzz0LJ7l95rLqXoG7HocvYObxCeH6tU/jDVgRy4EyQGRq6x+AjrKknn9Lu44HSFK+zYOD7UySpX8RQnhV9nIQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BLAPR10MB4899
X-Proofpoint-Virus-Version: vendor=baseguard
 engine=ICAP:2.0.219,Aquarius:18.0.930,Hydra:6.0.562,FMLib:17.11.122.1
 definitions=2023-01-27_08,2023-01-27_01,2022-06-22_01
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 phishscore=0
 mlxlogscore=999 adultscore=0 mlxscore=0 suspectscore=0 spamscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2212070000 definitions=main-2301270127
X-Proofpoint-GUID: 3ZcRfph89oF0y6eu7E40SyctBzlV47ai
X-Proofpoint-ORIG-GUID: 3ZcRfph89oF0y6eu7E40SyctBzlV47ai
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Jan 27, 2023 at 08:29:23AM +0100, Greg Kroah-Hartman wrote:
> On Tue, Jan 24, 2023 at 02:14:23PM -0700, Tom Saeger wrote:
> > sh vmlinux fails to link with GNU ld < 2.40 (likely < 2.36) since
> > commit 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv").
> > 
> > This is similar to fixes for powerpc and s390:
> > commit 4b9880dbf3bd ("powerpc/vmlinux.lds: Define RUNTIME_DISCARD_EXIT").
> > commit a494398bde27 ("s390: define RUNTIME_DISCARD_EXIT to fix link error
> > with GNU ld < 2.36").
> > 
> >   $ sh4-linux-gnu-ld --version | head -n1
> >   GNU ld (GNU Binutils for Debian) 2.35.2
> > 
> >   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu- microdev_defconfig
> >   $ make ARCH=sh CROSS_COMPILE=sh4-linux-gnu-
> > 
> >   `.exit.text' referenced in section `__bug_table' of crypto/algboss.o:
> >   defined in discarded section `.exit.text' of crypto/algboss.o
> >   `.exit.text' referenced in section `__bug_table' of
> >   drivers/char/hw_random/core.o: defined in discarded section
> >   `.exit.text' of drivers/char/hw_random/core.o
> >   make[2]: *** [scripts/Makefile.vmlinux:34: vmlinux] Error 1
> >   make[1]: *** [Makefile:1252: vmlinux] Error 2
> > 
> > arch/sh/kernel/vmlinux.lds.S keeps EXIT_TEXT:
> > 
> > 	/*
> > 	 * .exit.text is discarded at runtime, not link time, to deal with
> > 	 * references from __bug_table
> > 	 */
> > 	.exit.text : AT(ADDR(.exit.text)) { EXIT_TEXT }
> > 
> > However, EXIT_TEXT is thrown away by
> > DISCARD(include/asm-generic/vmlinux.lds.h) because
> > sh does not define RUNTIME_DISCARD_EXIT.
> > 
> > GNU ld 2.40 does not have this issue and builds fine.
> > This corresponds with Masahiro's comments in a494398bde27:
> > "Nathan [Chancellor] also found that binutils
> > commit 21401fc7bf67 ("Duplicate output sections in scripts") cured this
> > issue, so we cannot reproduce it with binutils 2.36+, but it is better
> > to not rely on it."
> > 
> > Fixes: 99cb0d917ffa ("arch: fix broken BuildID for arm64 and riscv")
> > Link: https://lore.kernel.org/all/Y7Jal56f6UBh1abE@dev-arch.thelio-3990X/
> > Link: https://lore.kernel.org/all/20230123194218.47ssfzhrpnv3xfez@oracle.com/
> > Signed-off-by: Tom Saeger <tom.saeger@oracle.com>
> > ---
> >  arch/sh/kernel/vmlinux.lds.S | 1 +
> >  1 file changed, 1 insertion(+)
> 
> No upstream git id?
> 
> :(

No, not yet.  I'll try resending.

--Tom
