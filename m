Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1E974FB4E1
	for <lists+stable@lfdr.de>; Mon, 11 Apr 2022 09:32:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245451AbiDKHeB (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 11 Apr 2022 03:34:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49398 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245465AbiDKHd7 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 11 Apr 2022 03:33:59 -0400
Received: from de-smtp-delivery-102.mimecast.com (de-smtp-delivery-102.mimecast.com [194.104.109.102])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D02D33D4A3
        for <stable@vger.kernel.org>; Mon, 11 Apr 2022 00:31:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=mimecast20200619;
        t=1649662304;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=neFmNgKe1iYzj5QuYNHakmxQcWytyjKozOA0SG2CAs0=;
        b=LtFq4G+K33YeDAqPuKNVvaYV4uNVGA/JPhdgmXrD0x0/uBSBB5nHomJpCBCS/vOMqB8uTG
        FGMNl04edvg1ophf7ebQD0/YQ/WJ8DonisKkIdPKI0SAO/RxlgYXK05+/mlh7bjf1yHpBR
        8f29sm0qlJIfsc0bxq5gJoOAoxWH7Jg=
Received: from EUR05-DB8-obe.outbound.protection.outlook.com
 (mail-db8eur05lp2108.outbound.protection.outlook.com [104.47.17.108]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 de-mta-41-__VcNRgJPoae0jYRdHumag-1; Mon, 11 Apr 2022 09:31:42 +0200
X-MC-Unique: __VcNRgJPoae0jYRdHumag-1
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Ls3rcNdMDJowQSMQo3hiSwK+4ygMDkNGtanNW0biqqI7NQVDfdtt7wLrBNm65ARD3E0XKAM0H/lYi6gDT0cA1FeGz04HaXAP32LXORMXArmDKD3ahJlJbg53NdFDLRaKLAvUzzHK/zNtY5ehr+8DFzzq9z8k24rCoBH07yiXL2qew3T6RXlTZKHx+gEm4OV0rBJfsPmYR2dxC0DlS/aaB8nHMMBcyfZU9ez4izxMSgb0XvSQz2EkOmaoUxy2Y3lx8PPnC1vjWIilm+iSf+Z6dR9+Y6OTzqN7DeHzFC4PY+U2R9T8Eo9TgYd13sYLHCy3ZDAGcYzcUVs4kq14FIQUdw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=neFmNgKe1iYzj5QuYNHakmxQcWytyjKozOA0SG2CAs0=;
 b=Xm11e+PTXT2BqS/1Or6WE1aaZhUxqAU+tivdEHdzbHk4X+iUPLVBqJhDNx2i5c39IUylHztFqw5EFccaRrKmUKEutXbadZbgXcjjGjhPu5IZrOnOhLdiIpYZKcd9fFkc4il4YMdIw8ufI1WAuKm4HT0Y/Dy9mjltPF3J5oS3f03ROWobIoQdudKhLcokmhB1jH1uCK+Zt5XpecDPqgHmJ/54r2EcIqqLq2+y1yyL2qRMk4Vgy+T4T6ZVKlai01dGVViWON/fyJqLR6Cvje45Ue+yVUyZPMHeqTLiKMN0BMofBnfwWSWpZI1eEWMKE+NPfcyYAKlRfZO61GQnHCUxfg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=suse.com; dmarc=pass action=none header.from=suse.com;
 dkim=pass header.d=suse.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=suse.com;
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com (2603:10a6:10:36a::14)
 by AM6PR04MB4087.eurprd04.prod.outlook.com (2603:10a6:209:4d::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5144.29; Mon, 11 Apr
 2022 07:31:40 +0000
Received: from DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::415f:1551:a6d5:face]) by DB9PR04MB9426.eurprd04.prod.outlook.com
 ([fe80::415f:1551:a6d5:face%7]) with mapi id 15.20.5144.022; Mon, 11 Apr 2022
 07:31:40 +0000
Message-ID: <06a70d54-9e04-2c84-43a1-b8e0a26a4adf@suse.com>
Date:   Mon, 11 Apr 2022 15:31:27 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-btrfs@vger.kernel.org, stable@vger.kernel.org
References: <cover.1649657016.git.wqu@suse.com>
 <2ce5b91dba107bba1ff56c9ebbadcd70e6d333e5.1649657016.git.wqu@suse.com>
 <YlPWSTqn5z19Jtzk@infradead.org>
From:   Qu Wenruo <wqu@suse.com>
Subject: Re: [PATCH 2/4] btrfs: fix the error handling for
 submit_extent_page() for btrfs_do_readpage()
In-Reply-To: <YlPWSTqn5z19Jtzk@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: TYAPR01CA0016.jpnprd01.prod.outlook.com (2603:1096:404::28)
 To DB9PR04MB9426.eurprd04.prod.outlook.com (2603:10a6:10:36a::14)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: b8670ac4-07bc-4a6c-4294-08da1b8d517b
X-MS-TrafficTypeDiagnostic: AM6PR04MB4087:EE_
X-Microsoft-Antispam-PRVS: <AM6PR04MB4087A13C4C4E05B09F520B41D6EA9@AM6PR04MB4087.eurprd04.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: SXcfNZUJ+6zrqVfYo0VJxkkwbe0msb0NAXzkHwTQoQ3cja7F485XEqXCHF3IBeUTMFEQIVmU+XHA09gI1l54kHsAIJxQeARwYO1w+WmUOH7lkwTKRLRTxFldztc9sb0MtyrnXpVuwWn44lpmG9sTlZhdeGdruSdz7SAfAAgkMiJxwKYWXsGmzGIwv27egJLpnE4Tg9yAFDTfoXIXYRm3EE+y1QJr9pGcgRMzm6vfka7SeAjdGPauLmC+iw9aOXVZwYtPHLI/SMdi8IZjsyj8ndaChULy3v9WUZwD+MhTbBappAVqtnv8VeIoCJGkNMF40fhN5+BZuOQqB8eb7YBG8Ls26i5zqGV59pxYbrLyiFsHVEOUahXmSBQ5vUAvtjbkJuYADhLmX8+vGI6c5p3eNArKcMbZ9VakDtt5nWVBSoBCT2Sg9cBQ1j3QHcAr8zJFsdJ0OjOkA7w0qypv5SSWGDlpEHkXApBIWACUNZkskljIPLlgPkFD13OQ+pWT4eRnRdE5MCx2KZk+CwX3kuqZarCRkVcukovDl02Mkkw3d9M+hY3Tdu6pQlQApIts6TpaWSx7QmVG5uERPfTslZZ2VynpIer63WUdj01Nw/NG2v/+/KaZvo8CT8faYd/cUUp097jhiuybUD9EPf+n5leUZ0emvFiEcaoQO42apiNZprX2Yy8GPGJ5Wn9Jzl4QWa5NKavyixAK0Tmsoiwd8yCf7/PAjGf4te9wIMAay0SnIME=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DB9PR04MB9426.eurprd04.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(366004)(26005)(83380400001)(6916009)(86362001)(38100700002)(66946007)(66556008)(2616005)(31696002)(66476007)(186003)(8676002)(4326008)(508600001)(6506007)(53546011)(55236004)(316002)(6512007)(6666004)(2906002)(8936002)(31686004)(5660300002)(36756003)(6486002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?Z21rS0dveGVwZHlYaHMxanNUZ0NuMEhkU20xVGI5Yk1NRE0vUkpGT2dyQ3I4?=
 =?utf-8?B?WTVuY3c2c0k2U1I0Y0FIZ2pMUlhRc0JybCtaMG5JOFhxZTJ2MVJzZUdCeXFV?=
 =?utf-8?B?d284U0JsRndzTTJOZW10bkV2TjhUNHFHOUl4NW80SlVkaWVSZEttSHdnbGZ4?=
 =?utf-8?B?OFNhMm5wYVYwQVQrSUgrYXlFZXRNMm1Va2ZiVHd0MG15d1l0VWtSQjR0cEdY?=
 =?utf-8?B?bjMvd2ZXNEJSZUJTNytnei9kVG9QclBNNUdQemRSbnBrV3pDVzkxVy9xajN5?=
 =?utf-8?B?UGNUZmtaQ21iTDN1NDlHamR5OFRaM2liNGFESGhXeWgzMExqdjR4RTcvNXc0?=
 =?utf-8?B?MVNycHFOL2NSei9PdlR0UnZubmcyaThzMjdLaURtZllyYXlQYmxTaUZrREdG?=
 =?utf-8?B?c1VXNkI3S0kyenpRNUd2dWlxV3VVZ0FJOGNiR3ZYQjhSVG1tL1V0ZmdDdWxV?=
 =?utf-8?B?bmEvUmhsbHJBRTlYQkZOMzBKTW5hWFNWbjdxcnlJS2x2a1FLQzZhbUFtTlhq?=
 =?utf-8?B?Z08xV2RPeUR6T0VaYS9rVWNvdnpNQTkxSkZUYk4vQ0E1dng2ZHN5b0RQQ2lk?=
 =?utf-8?B?OWp4ZDBxMGU3QkxxdXJYdmRBQnNFdlNHSDJuczgvU2pUN0czbXdQaGhYNkRr?=
 =?utf-8?B?R0VSc2dSVy9HMkhpUHJCeG55K2drZ09iU3d3SnAxZXlGWGIrOXRmVlkyQWZp?=
 =?utf-8?B?L2lkRjY1VFJYNUQ5R2pXQTJCUmdMNjQzZTlhWlZRckVnV3BGQ2JhUXNraThF?=
 =?utf-8?B?VGc3K2dmQVpBa2pNZVZjTXRGcnoxL2hsaVRteTE2cjlrQWNOMU9MVWhhT1Q3?=
 =?utf-8?B?Ui9zcDhQUEdWT3pMcG56RnZCTTdGK3l5K1dFdmhoYndLU2dNTnJKS21zWUxk?=
 =?utf-8?B?cXZpZjBiVTk0K0tYMUFvdG1wbU9JMS9zTmwvZWdBaStxbzY1SUY5a2RISytO?=
 =?utf-8?B?OXdmVjZSS015S3VUeVhzTXhmVmdRWENVSUZHZTZ2eTZESW1SRXRQalFreDFJ?=
 =?utf-8?B?aUZiS3g4aEoyWFNTK2wzV0xCd1Z2aFZHcXJBY09SQVV5VSt2ZTV1VWY5WXZK?=
 =?utf-8?B?QU14eldJenVyNUhKeEFRRmFha2NzQzJrZExaSi95OTMrUngvcU5INEkwOTRK?=
 =?utf-8?B?bTdqY2Zjb2RDSHVwbE9OM0dJZDlWbytoZHFBRnNtMzM2MHpXKzFEdldPWXNm?=
 =?utf-8?B?OUtpQzBxNkI3UFNBcTBOSEVhdTYxMThzVmxKdk95QzEwWHUzaUIzcHM2QU85?=
 =?utf-8?B?UGg5Y1VHbFFFbmlMc0lTNmNReFcxOWNTa2plWlcwMm83amNqKzNta2VXWk9Y?=
 =?utf-8?B?OHVYUVRhYzVzNUZkTk5aZGpONmRWNS9TS01qemZvdzE5YW5jN2MwWUhIZk44?=
 =?utf-8?B?aEQrNVJBWnRwYitOVFBBa2FmUDhnSy9nRkFBSFpSSTcyYW5XNmtSbDZVTkFL?=
 =?utf-8?B?bFd5RTBJUW4wWjA2c1djR3dTc0pmRWEyMDBYOUg5TmdrSUdCNDRuRnYrZnJM?=
 =?utf-8?B?eU90akVtcVRaNVF3ellWZ1ZBNVI3aDA1WlRWSEh5dzdydzAyeDBaQVhNSUZl?=
 =?utf-8?B?RGhIQnN0NW0zZW5PTmN6SEVvaGtrL2k5SXhERTh1Y0V0UHI5SVZZQ1NaalJp?=
 =?utf-8?B?bU1NU3NPNEtUeFpZcG1GWlUxWFZsSGN5RDdoMU9lQlhkUlF3NXJRQlptY2Nn?=
 =?utf-8?B?VFBOMDZ0S3IvbW83OXFkOTFlVzM2cUpzYjRPZ28vc3NDdEsrZHl0ekk5RDB4?=
 =?utf-8?B?QXBRcmNhQ0hoSVlmbE1QOEFjVUdGeGdPOStRZEZDREs1OW5NNHMxeXlCenpk?=
 =?utf-8?B?SzR3WHRUTmV2UjhyaTlTbXdneklFNlN6RW52QjdzczVQMVhQTk5UVzdDUU9a?=
 =?utf-8?B?WjNkM1VGSHJoR1cwOEg1VlVRZ2pMV25KdGs2Mmd6eGs2R2RHZUhGMTJSU1hI?=
 =?utf-8?B?ZjdIaUsrblUyU25GM1U0NEpsTy9jeEV2bHVTV0VrWW8xSGdxSEthRFZodUNU?=
 =?utf-8?B?ZzAwZitqN0J1VWNQSmJTNEJBYmt5c2x6blVWTkFsM0lKaC9vRzRWbWE3T0RN?=
 =?utf-8?B?TjRWejZQdkpCT21XSVRmeDFlZ0NIWGg4REcva2JsKzVOd3N2WE9LM1FwOVlF?=
 =?utf-8?B?RUhQRGNkK1JJSXdxVDZEblkrZHVTQzRnQVR6MzdKMi9OMnp5bTFTMnFiaUN0?=
 =?utf-8?B?REMvZ2I2L1V4RFIvT3c1eVU1Y3MzMjFFR2VzOEpDUU9ielE2SUk0c1ZTcENY?=
 =?utf-8?B?cmgzTXgrQlQ1d0hUZ2lYNWJsV1RsVjdrdWVsc0hycFdPaEdhMWIzNC92a0Qw?=
 =?utf-8?Q?ssLhcCkY094zGvA3dS?=
X-OriginatorOrg: suse.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b8670ac4-07bc-4a6c-4294-08da1b8d517b
X-MS-Exchange-CrossTenant-AuthSource: DB9PR04MB9426.eurprd04.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 11 Apr 2022 07:31:40.1010
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: f7a17af6-1c5c-4a36-aa8b-f5be247aa4ba
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: FcIxYIIkMXkvMDsijrivTc+33Vf3brBQ6Kqhcp5IUn5VuFq+9fNuEG0jBfiCMo0H
X-MS-Exchange-Transport-CrossTenantHeadersStamped: AM6PR04MB4087
X-Spam-Status: No, score=-5.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_LOW,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org



On 2022/4/11 15:18, Christoph Hellwig wrote:
> On Mon, Apr 11, 2022 at 02:12:50PM +0800, Qu Wenruo wrote:
>> [BUG]
>> Test case generic/475 have a very high chance (almost 100%) to hit a fs
>> hang, where a data page will never be unlocked and hang all later
>> operations.
> 
> Question:  how can we even get an error?  The submission already stopped
> return errors with patch 1.  btrfs_get_chunk_map called from
> btrfs_zoned_get_device and calc_bio_boundaries really just has sanity
> checks that should be fatal if not met, same for btrfs_get_io_geometry.

Yep, btrfs_get_chunk_map() related call sites can only get error due to 
sanity check.

But the sanity check still makes sense, and those can not be easily 
rejected by our existing tree-checkers.

So we still need to do the error handling.

> 
> So yes, we could fix the nasty error handling here.  Or just remove it
> entirely, which would reduce the possibility of bugs even more.
> 

I don't see a super good way to remove the sanity check.

The get_chunk_map() one is here to catch possible bad bio which wants to 
write into non-existing chunk.
To completely get rid that, we need a bullet proof solution to make sure 
all of our bio will never point to some non-existing logical bytenr.

Especially considering we have extra mechanisms to make chunk 
allocation/deletion more dynamic and harder to catch such situation at 
other locations.

Which can be more challenging than the error handling.

Anyway, we still need to handle the error for __get_extent_map(), we 
just need to do the same one here.

Thanks,
Qu

