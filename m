Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 442B96D1B66
	for <lists+stable@lfdr.de>; Fri, 31 Mar 2023 11:09:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231213AbjCaJJX (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 31 Mar 2023 05:09:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232009AbjCaJJI (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 31 Mar 2023 05:09:08 -0400
Received: from EUR04-VI1-obe.outbound.protection.outlook.com (mail-vi1eur04olkn2076.outbound.protection.outlook.com [40.92.75.76])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 556261D92A
        for <stable@vger.kernel.org>; Fri, 31 Mar 2023 02:08:56 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lm41QuduuVTsSUfQ9HhEez2VEF7h9xM9wVeqzY5zaEaw7dNZj+VtJpq/5Jtx1+lr4n46t80fkc7kh4jd9jM8W7O3zpidmYMq+qRm+a4ubI/gaDFFFexCqk37ij0KSHROlGOvY4Vom0aUSs2VLE1NPwSVjDGe7jNc6YViKPwzLI1c7zlnloa0A0ss+DiIOvZgSkA3ScrMq2DxSmQnKwpS9V/3HrdLJUZU9VjHuR6ecAXwOrM7WHTNee3e0V62qmeLt50Zrm0Eu2OfUH4OS4xANWMCeDmE/wMGhtP5congO5/CU0pXzoOZgfZlo7al52oHOoKO+J/aSTItqVyzu8QJdA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=8niAsrth9AV9GQJCvXT9MUP3VUprwN8VJxU+qjgmFEw=;
 b=kElxRopNiSQ2ahbXfABh430opWXZRE3N9UVuzhXEkPaA/phAFzcHjOUMwxsYABShgPyvHFBIHAq+ertiqGPfLqVDPdJFSZLpiI5K/QEFq6tSjDS3o5pAv8erF7zvaPUuU+91dKWi9JJfq824h7yMKlSWg6vrPaF8w62QvinzSzhkOyx0bgOfc25nD6Fitcji7GuCraJ+CArmWgY18WFHj5c8/9hoheoI3ReQotk6uVzO0fhtwAmQ0d/ljg3Ezj5tMibA+ZOCsBMxQwOvwSmtGXkkJjCjn7GcPkoE71q9FC34hqALW+dmGQCDyb09ci+1zRMK580VD1lch3cSEOE74g==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=none; dmarc=none;
 dkim=none; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=outlook.com;
 s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=8niAsrth9AV9GQJCvXT9MUP3VUprwN8VJxU+qjgmFEw=;
 b=rrQjlpOzYMaD6Y0uOGBKcfsCZkVkWj2IMnAN+E3SjAUNF1iDnENSpHO+WMrzxEMNYKZ79KZLX134HV6mXO8yIX57WT4krihTTN0AsgI1gmI7KF/bhRCiVj6EBEARRrHebFSt/1mj26N1dQMGAk9JLIfA5sbh/N7J7sE13gDL0pkLuUf1IOKU6PJ8lCi4EBMtcznQ/VTnQ8XE8CfG+8NhXHoHwH6MxS4JvcgXM762VIVz9Shl8LReE7w4mx22jNok7iiaHXBEdMU7+R17iaskw9V/lUm/f+cDVwHInEFZrnk+J257WmelFJ0aRXDhBbRNVTBkggunVrV3HGHBvzoLGA==
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:150:93::14)
 by PR3PR10MB4061.EURPRD10.PROD.OUTLOOK.COM (2603:10a6:102:a1::17) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6277.12; Fri, 31 Mar
 2023 09:08:54 +0000
Received: from GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250]) by GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 ([fe80::185f:8a4b:7994:c250%6]) with mapi id 15.20.6277.014; Fri, 31 Mar 2023
 09:08:54 +0000
Message-ID: <GV1PR10MB6241F8B5833F2805563CC486A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
Subject: Re: linux-5.15.105 broke /dev/sd* naming (probing)
From:   Ilari =?ISO-8859-1?Q?J=E4=E4skel=E4inen?= 
        <ijaaskelainen@outlook.com>
To:     Greg KH <gregkh@linuxfoundation.org>
Cc:     "linux-stable.git mailing-list" <stable@vger.kernel.org>
Date:   Fri, 31 Mar 2023 12:08:51 +0300
In-Reply-To: <ZCaULkVk6iHHJYm2@kroah.com>
References: <GV1PR10MB62412F2794019C35025C7360A38F9@GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM>
         <ZCaULkVk6iHHJYm2@kroah.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.40.4 (3.40.4-9.el9) 
Content-Transfer-Encoding: 8bit
X-TMN:  [lpOFlU9yo20G9uhdJs+WsSIStgRKSFp+]
X-ClientProxiedBy: SV0P279CA0046.NORP279.PROD.OUTLOOK.COM
 (2603:10a6:f10:13::15) To GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
 (2603:10a6:150:93::14)
X-Microsoft-Original-Message-ID: <e0582ff4dc3aa82295897d300d14cadbde0c9434.camel@outlook.com>
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: GV1PR10MB6241:EE_|PR3PR10MB4061:EE_
X-MS-Office365-Filtering-Correlation-Id: 567c6e13-7cc0-4182-dbd3-08db31c78d10
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: kUkaRpEULIprDy9Vke5ZzLvVfnFGpiZU3MFqm5zGFgx66bjRHtMvcsMjpuM9whQX5v9UELucc+k4iSNl6OVXfnHRvyGkIpeQSWp0pnB2RTrjQ2xmtMOWdUiZ+l7p6cBhYZcsThnxeEyH5SaHjy7XvsSB24DDyLf+WUR/IMnq5NOuDu/szjjg/WT602uBBhUlS+txNiwqfixIwqOFe6E3N+zlgZs0/s1cFDKkyFRo3W1qYNLFv9cAZ2leosGg6v4Il98Jf2vSzPwQKSSrSo9TCpM9aG44k/Z23J9gVPdntOHUq4wwjq3QCgCSNNS/1srqKCDrIa6wkil6GoSK2gcyVr81DuBV9t2vKhd5f6CLLUwuvQlz/7wR1d+pew4uOntkd+iOucZafvP0WJHxIoSf5RKsNmy/unp7PnvKYtRwixWX4w+3ApZwpeMTEOhmUsWsNI8yYB2d2J/rSxiYQahf4kpwR34Jgfqe3551AXSFjfuWDIG8KhEtJWhnJZoq1QdfuoONgKIwZEZdnv4xkS30RwuE/byFifGeTyC7HSRaRKzzS+R87DtN9UgzipKnsmff3A1il6YNB/83ancbq6/zF2qLLbCGFkQnJWcP/ffg0a9TMr/Tu+ilbJ/6O73wVFwD
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WWRsOXQ0d1YwTmI1QkN3ZTNKRUVncDdHU2lSWkE0ZmdxYmpKclVHN0MrQ095?=
 =?utf-8?B?MFdPdlpvQ1R3VXhpMTlIZFVjcEt4M3JUOEdjem9KUVdIaUdnTEJjdEV5RHZD?=
 =?utf-8?B?VGxYb1Y0QTROZlFyY2RJUDZTNS9GSGZ1V1pOaWw2Z1FzcGFYUTU1LzIyZUNE?=
 =?utf-8?B?bHhnKzNoNmlURUl4N256dUNobkdPaWxENmpZeU5BM0FvQ3hONnRmcTA0ZEhK?=
 =?utf-8?B?SnNkMnZ2TS9lbjZqdWhvMGhzR1p6MGczVFdTMXFxUkpLZ1BrellEMGhiTlc1?=
 =?utf-8?B?dE9Mdy8xNzNGbDZVY0hlYjlBWGo1aXRtM2lwdWcwVTFvOGsvblVsYlBsdUgv?=
 =?utf-8?B?QXdQL09YaERHdWhPZ1BoZzNTSVBKNVM2dWpUaStySnV4K1pxZXlhd1Zsd2l5?=
 =?utf-8?B?MzBEZXIvQWFNcFBDUm9oaTVUQ01meGlvQVhqR2FITHU3TzhIYkE5d05DZzJk?=
 =?utf-8?B?N2w1d0RQNEJvYjNHTmdGdXBxMGhTVTdOUXdwdDhIQyszcThpeHZSOWV6cS9P?=
 =?utf-8?B?VGRoM3VxTzRBc2xJbWQyUHlhWDFQb1NrOWFndWpFNEdCWmlsVDJtWjJ5elcy?=
 =?utf-8?B?RlpJLzJ2NzhHUVNYOVZqZERVZjlGaDM2M0dkNm9BUmlwR0JXYThsdVJRK0R4?=
 =?utf-8?B?MzFJSndrRk9QQ1dxditXTGxNeENFL2RhK05hamdMWDFGWTJtZWZzUVJPN1Vn?=
 =?utf-8?B?cFVqT1cyZzU1MkVsRDdndER0TWNJd1BqL2o0RVNTM3hJQkxIZ0hLb2hxVUQx?=
 =?utf-8?B?VHlFTi9xeHFQdTVGZEw4QkR2TlZYK2tCU0s3b3dtYlZ0M0ZxSlN2TExtNmNj?=
 =?utf-8?B?MDBvMERxUmR6SlZDUEI3UXVob0xDZDVxU3RzMmMyd1pPUGpsZXV0cXpVWUo5?=
 =?utf-8?B?MXArdFRRYU10NmhEbTVOM0FOWllObDBTeHJLeTFla1RYSXkrUUtEQ1R5NjY1?=
 =?utf-8?B?MklublZJOEI2Qmp0bUlOQThVZGpQdG5RcEFZSnV2c09sallzMWtOVnd3VEhw?=
 =?utf-8?B?ZytmQ3N6bGNjR0Npc0NsVlRBOWhONDByZWhkaTF6S0ExcDRNdzZxZmlMUEVP?=
 =?utf-8?B?L25OWVBQOWliRVMxejlyM2lXaUx1SU95Ry9CTTIrb3NiNUJDZ0RibXo0NXkz?=
 =?utf-8?B?SUlsaWF3RmltU3cxdE50S0p1V1FqUk5TVXVOSC9mbnJmZVRiVmZXZHhEODZY?=
 =?utf-8?B?dUVPa1ZFSGVVNE5FcUpFVDUxWEVGVDlUQll6Q3pkcmZZdzZPOFl3Vm42MkFa?=
 =?utf-8?B?VVVWMzFTcXljY0svTmkwc3lOdW0ydjhVcE9ubkpiNTlHOVhLRDlaNGR6d3A3?=
 =?utf-8?B?RnhKbDBBMDUvZi9FYXM4ZG5vamFZY2ZBbld4akViazVWWU05cExiejk1eGpV?=
 =?utf-8?B?TVJzQlAvcjQ4UFZnR3VjS2tOOXgwNzdmOVhqU3d5NStLenVJaGdLWTFQeE1K?=
 =?utf-8?B?TWo0UXNpUXJzeUJoWXpCVUpQeElxeHcwMlRqY0pwc1pLRFhEQmw1cC9XUEt0?=
 =?utf-8?B?VGsrSy8vaDE5dTRGYmM1M2JCVVVHdGdxYnhFWWF4eVNYRnlzTUlPSnNEdWlx?=
 =?utf-8?B?OGZicXJDNDVuSk03K0o5RFlOdWF0bnhqR3I0L0tjeVpSZHZ5SzJOd0lYVWpj?=
 =?utf-8?Q?H/QwOeti5OhxvO9PH9m/ADCE7MqXRkgDuVG/y8fT6/W4=3D?=
X-OriginatorOrg: outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 567c6e13-7cc0-4182-dbd3-08db31c78d10
X-MS-Exchange-CrossTenant-AuthSource: GV1PR10MB6241.EURPRD10.PROD.OUTLOOK.COM
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 31 Mar 2023 09:08:54.0671
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 84df9e7f-e9f6-40af-b435-aaaaaaaaaaaa
X-MS-Exchange-CrossTenant-RMS-PersistedConsumerOrg: 00000000-0000-0000-0000-000000000000
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PR3PR10MB4061
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

I am afraid I cant do that. I already almost wiped my root partition by
accident because of this flaw.
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


