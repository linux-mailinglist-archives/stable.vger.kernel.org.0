Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 691AC6D1BBD
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 11:16:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230456AbjCaJQ0 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 05:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231703AbjCaJQM (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 05:16:12 -0400
Received: from EUR05-AM6-obe.outbound.protection.outlook.com (mail-am6eur05olkn2084.outbound.protection.outlook.com [40.92.91.84])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A7A23C10
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 02:16:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IueIuZFYd8osjXV7fsKwMB5XY/jjiMf2uEa+JDEbisWoEQW1ODv/QnbQdfd3Puz0BAE3HF67RfEnubDeC/nOuNlbZglhncf9nI2pSG9Fd+oC92b0U/0HFIou55383+VBe/hjGPGpwAPl/cMYOaMU9y7T75jv8rarKFtnlcBmRXRxmdtIbU6GE6KeMmL6eutzb+S078eXi1vIugm5Zr3sImfLTs1527usb4zcf+3AjFa7yv1DvKjIpQ12rYyHSRxrB0VndtT44by4XQjXcGZkdYnmeIRbTngiR9eqKEnJR5k9mrQ6Tj8OswBk6YivGuCGG/7Ms5g67SHzY1DCniThoQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=DhPSHfvTSNt3/L8k9cRK2jpIk3P3vc0LduPkTSQogNU=;
 b=hf0ybwo950bTp0y034RjU6GAJo+4tdF2NpN5u/UoQzNItPmxhXGDGotQWpLDpMnagqiEcYP6ytTH2iHLRrytBeElqdnZ5XYzgKBYwvqDtgqMjjLfTrkcqnSZyP+yNumH02sslpgTxxpcyDvMRl/Y7OAbuwKxJMVJAtVA/Pr2pukjloN8JrKgip0coZoBb1MjZSXhPDMj0DhP3xP2L8u0iwrKr/4Rn5INu7HbFu9mCFlsEK3N08IN5OJ1y1M7ltY5n0TMLQXkZOx43uRnd9RvPppjYeuCILkVCrNLKMQYg3zq5BzUAZNXQzJeb0jY797Zg/rgDiqa3vD1sEmTDC0iFA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=DhPSHfvTSNt3/L8k9cRK2jpIk3P3vc0LduPkTSQogNU=;
 b=Ddw7aTaW1EjkoiCnvIl/sD7SdFpo6FRkzcQk/TPLNsy0NfFJZoeNlifqKibA8yPD4Ub8+zATH/9qt8M5TucfjmueFIvwB3qOAKXMpWS7Pyg2NmLfVm/jriNam38/Qe7aDDyZPDxo8S+JvXxNUn9G/5Ddn43ETw/GfqoC14e8EzoZ83Kwu+UtvKFiJG8nF0gx6u5lzQ8bD3J7Pqn37QYRyBfBsASozAcRlYaw3tIkO9+BAEnHFFo57P8cyBnGaRREOeY2TNRDJ5LfvLNlyxyR4aQb4bhiOL1E+yjPgFjIzYMGaMkdX86gQqHq65TVUE542vVqSKfloXtbV4TuMQihzA==
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:93::14)
 by GV1PR10MB7598.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:87::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.13; Fri, 31 Mar
 2023 09:15:59 +0000
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250]) by GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250%6]) with mapi id 15.20.6277.014; Fri, 31 Mar 2023
 09:15:59 +0000
Message-ID: <GV1PR10MB62411019AEADD4562BBE1421A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
From:   Ilari =?ISO-8859-1?Q?J=E4=E4skel=E4inen?= 
        <ijaaskelainen@outlook.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Date:   Fri, 31 Mar 2023 12:15:56 +0300
In-Reply-To: <ZCaULkVk6iHHJYm2@kroah.com>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
         <ZCaULkVk6iHHJYm2@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-9.el9) 
Content-Transfer-Encoding: 8bit
X-TMN:  [s3Bh/1qQAmTLRaV2Rt7/oqBS/KvS5wZv]
X-ClientProxiedBy: SV0P279CA0033.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:f10:12::20) To GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:150:93::14)
X-Microsoft-Original-Message-ID: <1a19d3fac69f3e294c023a91b6f679747280665d.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR10MB6241:EE_|GV1PR10MB7598:EE_
X-MS-Office365-Filtering-Correlation-Id: b9d9cb6d-a88f-4cf0-a894-08db31c88a75
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: F/Lgk20Yr+SzQ3dhyephZdP1b2+miucJrl0/UoLeI85iqB4lq3VgeQRlgZqmzpwPLzFoPpnaxggWGMRXGD09uhsReVJucidAm3Wq9uGgt4Dni4cBxRMcINeAsoOLj8CDBebYxuVcmLtet6qTi0YhwVu1UQzlw9CnqrC/L+LTp4pzt7SpIslq58nFIfYnB+VnDUJQyMmiC5JJpDo41N2bZW/bcHZvXDo/y3cYjSDk0IlvaRMxwskqW18nxMtkkGFKyOY5k5DeSKC2cWZIbztCLLcNEHxrfOPwnVHwRZkVEqBZldVwjPOGIjjulNHAC8I8akk++ilcm07uRkS5zcIt1QgyYB7xas03827hW8wJ8CdC4ATI/IzALCju9kQAJZ+7qvqcFtq1fm805UCUwYWX17nbgqbiNH4dkJUjA5noYs6e8SnavBEuqBpjQaGSv3yHHJDB0U4OyEQoin6h8z57rYwVp+U7x3SU+RzfWq4j/Dw6EAsZwJ11uiseTRgkbGw/6MRbC2lVdmWBgcdQqh9UatayRVbNFkLYrO2YWGxAdixn9t8DAfo/e58dHQ2VRUe9E3W/aRnz2EyQSDZ247MPDVPCzIlBOS314Dw83IkXl44=
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?T3d1aTVGTU5DdXVOMHhYaGlLYkFEOVI0eG9DNXFNcVQyZHp0ZUVjWDR4d05O?=
 =?utf-8?B?VFFJeml4UDhrNmJHODB0UTBuZThjbVEveGNVTE1UU3NKQWREc3p3QnRIVFli?=
 =?utf-8?B?S040MGZpNmZhY3NQYUdFdmNBcTV5VlQzakswVC8rSmc2VlZOVzlwUFVtVmlQ?=
 =?utf-8?B?NlR0Vnd5YjQwWmFNb2Z3dlRremR4cDRQTXA2K2ZieHY1dndUZnJOZ1FaS2dj?=
 =?utf-8?B?YnhLL2xxeFVSaVlGempDdjRnVWRqZE1LOWFOdHV2cVpyMzFqYVpDSTRkcTB0?=
 =?utf-8?B?K1Ixb2RJMDBaUEJ3Y3Zkd25Va2M1Y3k0TzZXSm02LzZWVUNray9BRExDeEtT?=
 =?utf-8?B?MlFTSnhLQStzNlVtaDdlTEF6ZUZtSGdCbnMvY1JIVXNsQ2YwaHZyT2YycTNh?=
 =?utf-8?B?d1JpNlBJa3ZFWU00Q2ozTXRlN2Q3ZWtNL0cyYytzMnloWEhOQUljSHFlSHRv?=
 =?utf-8?B?eWJ5YndGZSt5T2ZIVk1MWUFqVEp2S1VLeDdpWnROeGFVNVRRVkpQaHJXWDky?=
 =?utf-8?B?Tm5SU216VXl3U0ZQZ1BsaGt5Z0VSOEtDK0h5bjF0MXZzUEJJSUVoVDh3bEts?=
 =?utf-8?B?cVhJbDhpLzBhaTA0TWxVbU10dHZwbkRBZ3FpQlZWUEZObkVzQzZYWXFmcHEr?=
 =?utf-8?B?QnBwRVZRSFJMbzdaTmo2ajQ4akloYUZSSGtwQ2svdzdDbEZMbUlpY1dvRWMr?=
 =?utf-8?B?NWgxRVY4TXk0OXd4cTc0dTJxbGVpYkRna1o0blZLMXpYWEp3QytXaUI3SzRa?=
 =?utf-8?B?ZTRUK09JRnJQYXhNcDRuSEJ6K0Z6eFNqcFo3a3ZnM1Jaa3NRYVlPMFJ6Y0NJ?=
 =?utf-8?B?dG1mTW45VXh4b0tIZWlmZGdqNUhCTWxZN1pEbEpFMFhKYnRqVW9OZnlpTlVr?=
 =?utf-8?B?WThqRXNjS1dKa21xVkZubThIb011bE0wbzJVcXNESVNCRk43cERXeWE1UUVF?=
 =?utf-8?B?NGo3QXBGa3kzb3JQUVh6VW5XTHVsdlFucFZEVkxSWjZtV2tPaUIwWXFaQXA3?=
 =?utf-8?B?akZLb2Q1QzNJL1JRWWVyd01RZklUSEdSc3doSVh1Y0JvcHdpdndpaStSSVh0?=
 =?utf-8?B?WGIzZ2hWN3NMNnF3ZWVuSVhGMTMvaEo5ZXFDbWFqelFkN0tQRDNHNDJsYysz?=
 =?utf-8?B?eGxPL3d2WUExSnRXM3NHaHVBdzM5K1ZOaXVINFBBNGpYUGl6Vit4cy8zNXRw?=
 =?utf-8?B?MzFIYmNmdk1hWkxlL09iK3dVemxTdWZaNGZPRkhDRXhkcjNpUEQxQWd2ZlZl?=
 =?utf-8?B?YmVIOXRKd0U5TS9maWhFWlhtR1FXMzBpNGJFcHpmYnFPMmw5dDlZK0xEV3lG?=
 =?utf-8?B?MmY4Wll2UE42bGtVcWdCQk9vRVdYUWJSZ1M3NmYzcDdId1pMQ2ZsRDdmSGpt?=
 =?utf-8?B?bEtmQ2VtajhWSjZjaXY0S3ZMSjBzWmJVdFFVRWV6MlBLSkEzY0JkVnlqQ3BD?=
 =?utf-8?B?ZUhjUzBGMUVEeEIwd1RVWjV1YUxaT0ZSaEM0bW5LaS80cWRLdFJCTm5uWW1B?=
 =?utf-8?B?K05qMTFrTWc4K3RHUytIa0trWlZyWGVCeExuSjhPQ2hOQjJoUldIQTVjT2Rx?=
 =?utf-8?B?Mjh1a3hvaWJwVVY5T3Z3ZnlBRlBmU3grdHlXUVV1SGxxUGVoWmtvUHJJbGZo?=
 =?utf-8?Q?/HpksdcBnz4y4n0pjvXoYuiYokZQyUUQu1J1O/GlHS7k=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: b9d9cb6d-a88f-4cf0-a894-08db31c88a75
X-MS-Exchange-CrossTenant-AuthSource: GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 09:15:59.1556
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: GV1PR10MB7598
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am using https://www.kernel.org/ 5.15.105.
pe, 2023-03-31 kello 10:05 +0200, Greg KH kirjoitti:
> On Fri, Mar 31, 2023 at 10:52:55AM +0300, Ilari Jääskeläinen wrote:
> > As I attached a USB SSD into CentOS 9 Stream computer, after a
> > short
> > while it swaps /dev/sdb into /dev/sdc and the I/O gets ruined.
> > Kind regards, Ilari Jääskeläinen.
> > 
> 
> Is this using the CentOS kernel, or a kernel.org release?
> 
> And if a device changes names like that, it implies it was
> disconnected
> and then reconnected, what does the kernel logs say when this
> happened?
> 
> thanks,
> 
> greg k-h


