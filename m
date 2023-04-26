Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5D436EF1F3
	for <lists+stable@lfdr.de>; Wed, 26 Apr 2023 12:29:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240253AbjDZK3u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 26 Apr 2023 06:29:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240300AbjDZK3o (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 26 Apr 2023 06:29:44 -0400
Received: from NAM10-MW2-obe.outbound.protection.outlook.com (mail-mw2nam10on2085.outbound.protection.outlook.com [40.107.94.85])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC3149F0;
        Wed, 26 Apr 2023 03:29:43 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DM3mT3NAGmLIBN+c7mlAY0UgW1Wga2RSFg/1z5l/gHIN8hk3/6Vs0RLyARIGSTC8RR9daYnxSP92LUA7b9qQUS2lVvUknLldJTNWaN2/3+Vz0Vvzm6ArgSMyEbYrFEiY2vKl1culqETYr0wnFLnEC4D+yXrrpKzAdmORGV4Gqkrc4tUUBMKC/cpabXW3KntWljUAHXHaeb0q3U/XLLqogZ7rk3OlqzwLAa56pkMBfGHUXtefJ/beuCqTTsOdgaZO6td2Ys8rlrxNuG/jKo9D0MH/PkZqF2gFXLtzUQwUYbAgGYS5yPMJ/Y5Z6ZjA1bOlI8ioP/IhVcxBkhZNvpPJSQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=OS4s3SFUBI15+YziQEswE+UrIXuNAKgj439Dl4HbZdU=;
 b=Hwia+BmkNJgagAEvROsGrhFHjNoO4unRMaKG0Fp6leVJ/+rRQnR2RGNlkcZmCDZYEY4ZoiMv+pZsCT20SmWTmEszhKekg7sUpk43YtTENDx4JICJXk8ZQU41ATkj7S2wvH6KIvC0h+DUTB0WsMEa5w9Z9v7EaN8BgRGEGJOgAimYDhnXpQRSJISB5372kxDYqLvSDmsX68JBXPb1lobil4PxGGieLg2XPxkrKCqB9qjr1mg+yPg4aEYkPHqcAjlq2Yu3n75UJp/CvGJDVEax4CXga1wUW8IdrsDzHuXvCOeBa662skaWN5/yFC8I4rofFmSHZsVo7+aZ8oGzPsf6hQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=OS4s3SFUBI15+YziQEswE+UrIXuNAKgj439Dl4HbZdU=;
 b=IwKw5F+DOf1Pw0b5T6UrJJHyK6luOcuKFzkCKCY17hcx4bVnTBsdPVxMjwd0dzdmp4eTQDHib9lxl7tzRiGMladNZPUP3XZgwkQPpHVE/5a5g4StKmSkwDRebki6sL56mAz9jbyXPz577kr/xZOXH3KvBQvN3vse67LXybWsOoY=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from BN8PR12MB3587.namprd12.prod.outlook.com (2603:10b6:408:43::13)
 by PH0PR12MB8799.namprd12.prod.outlook.com (2603:10b6:510:28e::6) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.6340.21; Wed, 26 Apr
 2023 10:29:39 +0000
Received: from BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed]) by BN8PR12MB3587.namprd12.prod.outlook.com
 ([fe80::d2f8:7388:39c1:bbed%3]) with mapi id 15.20.6319.034; Wed, 26 Apr 2023
 10:29:39 +0000
Message-ID: <b76af325-0b4d-25bf-a009-fbbbb3f99146@amd.com>
Date:   Wed, 26 Apr 2023 12:29:32 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.10.0
Subject: Re: [PATCH] drm/amdgpu: add a missing lock for AMDGPU_SCHED
Content-Language: en-US
To:     Chia-I Wu <olvaffe@gmail.com>, dri-devel@lists.freedesktop.org
Cc:     stable@vger.kernel.org, Alex Deucher <alexander.deucher@amd.com>,
        "Pan, Xinhui" <Xinhui.Pan@amd.com>,
        David Airlie <airlied@gmail.com>,
        Daniel Vetter <daniel@ffwll.ch>, amd-gfx@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
References: <20230426004831.650908-1-olvaffe@gmail.com>
From:   =?UTF-8?Q?Christian_K=c3=b6nig?= <christian.koenig@amd.com>
In-Reply-To: <20230426004831.650908-1-olvaffe@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: FR0P281CA0163.DEUP281.PROD.OUTLOOK.COM
 (2603:10a6:d10:b3::17) To BN8PR12MB3587.namprd12.prod.outlook.com
 (2603:10b6:408:43::13)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: BN8PR12MB3587:EE_|PH0PR12MB8799:EE_
X-MS-Office365-Filtering-Correlation-Id: 946d3186-916a-47f1-6c2d-08db464123b2
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: +nKgQolhmzZNEit+34y2Py3cWqJXQ4sQPBVNxE7tDMBk9pNLnNp/U7O1T6/GLwtFcBOBqtGSvOnrv05GRpfiQYxXIzo6bhlIGAtrV5mainnb8LeOQBvWRn0XQskXeNc11rEv1cwqx432bm0uAYU0UVxmJkFMakguzJJLZ6HBzdP31K9Z/m/gcmiQwHdeLfFoDI1CEzdwZ/TRHtRKhehOF3RhC51IdQY+uaiBPYICfJ0jh7m31GRAkdnmr0JceI60w+dbIIk4o6JvcNmBB3CaY6K+owrtx1POa3uX1Kb/kF48LSACwMRlsySAwYj11weauund7VFvWsU6cZCu2f4yl5Z6059t4ljn7qTH2lySs3XRTqrPv1gIOAtz5tYQVBreaPOT9A2gKQ0k9GUS9ev32HqjJtyztKOh0V3yBfhbJ6SGnmYVbssaqEXNjQm5ewqKWlk7Vd/8ptP8MJbpaHIkT/+lrHFrr5/iA6M/UJP5m2JP/0JpXnVREeRJql6oYJomlUZbKPtrZojFTuPucCavPNaNfSdz3RAnob810i+u+0LENzfTV2RUMg9i2cFGxPReoeDK491UN5k0RvZ6Su9msfGe6kZK1m4O4SuoJvyWXbBjSa8qKAlaE/bTaky7OS81tP3xZmhL8zBRBj6uW0EKyw==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BN8PR12MB3587.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230028)(4636009)(39860400002)(136003)(346002)(396003)(366004)(376002)(451199021)(36756003)(86362001)(31696002)(54906003)(478600001)(6666004)(6486002)(8936002)(38100700002)(8676002)(41300700001)(66476007)(66556008)(66946007)(316002)(2616005)(4326008)(83380400001)(186003)(31686004)(26005)(6512007)(6506007)(2906002)(5660300002)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?WFAzZ0NTcFVDSFZrdEQrUE90Z0Y2UXJkbWx5TzVSd1pzRkp5ME5SUkVZYkpU?=
 =?utf-8?B?VU43UFcrUTVNMWVEeTVNakJ3aU02elI0bDdISXd5RGNtMi9aZmRGeFZBS0pj?=
 =?utf-8?B?VjgzSGVGQndoOE84ZHk4MlhuNXRUSWJqTHRrblBoNkV6bm5rWm5jeXkzbmh4?=
 =?utf-8?B?bGxWdEpjUWk2Mm8yU2JhVmxmNmZma0J4V3BUMXlmTUt3Q3Byd014dnBWWVVh?=
 =?utf-8?B?bmVqUWFMSTVmUS83MDI5U1lUU0tCRk5LcU00VG1TRnZnajVubGx2alczYWpU?=
 =?utf-8?B?MitlM2lhUkp2REF5cHUwSDAxdi9FWjJLcDNWa210M0RSWGZKZXAxc0tVaU81?=
 =?utf-8?B?TnBHYVVnOU05TFV4YWdZaWJZQjQrM1hVU21Icy8wa0dVSitTOG5waEszc3BH?=
 =?utf-8?B?cVBlSnhZV000dU1URk02ZkNoaG10bFV2Q1hneTc0ekQzZjVyUFROOE1hK1Ry?=
 =?utf-8?B?ampQMWMra2h4YWovbWVpMnhZNCtYendpdTEvam9CTDhxRCtqczZpbFBBd3V3?=
 =?utf-8?B?RS95TExCTisvdXAycG9iWnZvRko1aHlza0o4NWI4QTlHYS9hOTJ6eGRiZkRt?=
 =?utf-8?B?SjJoR3AvSk9FL1ZUcFF4Yy9CcS9jV1lwL3VPUUFJWDAvUk5qNHJDenNUanlY?=
 =?utf-8?B?c0FsSjJLUWFDQkZVSnplam5xUGtwQTV1VytFemVYSzJ6cU0vQVkxaW9qazBS?=
 =?utf-8?B?cEd6MUtTcFZCNURlQ1NQM1c2dmJGMzE1WE1qdThmZ2xWOXQxZmw4emR3ZlR6?=
 =?utf-8?B?b0lDbUNJRlpucGY1MkFIdDJKbG0vMjRBRmxHcHJHcThIUEJERm4xZFdsdVJX?=
 =?utf-8?B?c2k4QnBhRTBsWURZZ0lGbVkvTDgvbHZSMTNGazQ4T3BPSTI4dnl1eEF0NGd0?=
 =?utf-8?B?Slc2Y2tWZm1ieHFvT2R6VzQ4NmhBbTRnWDJIK2dRbnFBQUp0dTdTNUludCta?=
 =?utf-8?B?TzFGUWMrWXB3a24yK2tUZWVXWUtBS1ZmV1JybXlkOTh6Z2h6RUtFM2pZeVVs?=
 =?utf-8?B?eGJ3eE9DT3lTeFVhOCt5V0t6aUtXbWZHS05pUm9pTUlhanY5N3ZyRnk1QUh4?=
 =?utf-8?B?dXhJSk5iUmJSRlJNRlFXUmxLSFNUZ1BBMmlUR1BCUjN1UDlaN3BZQmRLbTg3?=
 =?utf-8?B?WUFsS0hnM00wanZjSTZSeWZ6NnJWT2R1clRpUnhQelVCMUpDVTVHMkdISGhv?=
 =?utf-8?B?ejcwekRMZ0w4VUZHWTVKQjNJTzZNdTRvUVJYM3BEOGlSVTUyWkxleGRPd3RG?=
 =?utf-8?B?WHNJWWQ5bnBCYm0xellqbHlETnBUcUVHRXNFQzdJZHJ6bGdLbG5ESGNhUUtZ?=
 =?utf-8?B?ZnhDQS9IN081blBHQlFRVWxka0luVFBwYy9jR0ZRaWVzcUVTYTM2Q1BVL3hG?=
 =?utf-8?B?dlFRVlI4NWRZbTI1cWhwZ1ZqTmRMV3NabG0vS2NoaE1JVy83d0FWYkRrS2lz?=
 =?utf-8?B?UkR6ZjZ2VGMyOTJwcWxiVmVmL20xb1BqOU82dnNhMEJnZGlhQzd6SGlaU2hM?=
 =?utf-8?B?MGVqdVk2RWV3YzY1WkFFMG5Mbi84S05zTExMMmMzakZ4U3E3S2EwRTZpY0R6?=
 =?utf-8?B?MWJXTWZxZGYvRmx5d1B3ZTNadDNSUWVyTk1LSW5LSWdpOUZtUWdBQUVaSjRW?=
 =?utf-8?B?Vyt0enA1U2tkZEh4akRuSnJIUlhBVjB6TC8rZzcxcHVKdm5hWE9IZHl1enVU?=
 =?utf-8?B?eVFXbEFMdS9FSjM5YXI5UHZ1emhBQnZDY0lieTh1REZDRTJMR1dyVDNkdzhV?=
 =?utf-8?B?TkI3R3VEODJEZVQyNlViUWN3YldQMktrSWttbExWQW44c2pOTXprQWtPd0Zs?=
 =?utf-8?B?dnJRb3BHc3VkVU1WaEhETFpsV20yS2w3cDlzOEhGM21tZlZzRTdRYkxvYlJq?=
 =?utf-8?B?b2doaWVLeDM4QlRFSXFINjRDQ0lwMDRaRHplajFyYThTVXBhbGJDTng1ODI1?=
 =?utf-8?B?TVRTdWw1TERqekQyMkMyZ0JMV2RpSXRzL0VvZlN4dTQ0L1NGb0pwd1FkWXpu?=
 =?utf-8?B?WWV2Nm5JbkswYzBMWUpIM2RDWGN4YzdiaGRJbVV1aEZ3WEUwS3hJS0U2REVS?=
 =?utf-8?B?SkljYmx1V09kdnU3dDdubG5iSUp2dllGT241dTJ6K2hwUnpZK1ZuSXRpYklS?=
 =?utf-8?Q?pUjCEmPrLbAxG/KkGCXFq/Kul?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 946d3186-916a-47f1-6c2d-08db464123b2
X-MS-Exchange-CrossTenant-AuthSource: BN8PR12MB3587.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 26 Apr 2023 10:29:39.1300
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: X0OkgdJ2HUjcdkCf2cMxZq/OfWv7fFGRA3hblIRN5yc9lEM2MnA/Jf9IeMIm02cO
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR12MB8799
X-Spam-Status: No, score=-2.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FORGED_SPF_HELO,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_NONE,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Am 26.04.23 um 02:48 schrieb Chia-I Wu:

Good catch, but you need some commit message here. Something like "Need 
to hold the lock while iterating the idr to make sure no context is 
destroyed." should be sufficient.

Apart from that looks good to me.

Regards,
Christian.

> Signed-off-by: Chia-I Wu <olvaffe@gmail.com>
> Cc: stable@vger.kernel.org
> ---
>   drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c | 6 +++++-
>   1 file changed, 5 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> index e9b45089a28a6..863b2a34b2d64 100644
> --- a/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> +++ b/drivers/gpu/drm/amd/amdgpu/amdgpu_sched.c
> @@ -38,6 +38,7 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
>   {
>   	struct fd f = fdget(fd);
>   	struct amdgpu_fpriv *fpriv;
> +	struct amdgpu_ctx_mgr *mgr;
>   	struct amdgpu_ctx *ctx;
>   	uint32_t id;
>   	int r;
> @@ -51,8 +52,11 @@ static int amdgpu_sched_process_priority_override(struct amdgpu_device *adev,
>   		return r;
>   	}
>   
> -	idr_for_each_entry(&fpriv->ctx_mgr.ctx_handles, ctx, id)
> +	mgr = &fpriv->ctx_mgr;
> +	mutex_lock(&mgr->lock);
> +	idr_for_each_entry(&mgr->ctx_handles, ctx, id)
>   		amdgpu_ctx_priority_override(ctx, priority);
> +	mutex_unlock(&mgr->lock);
>   
>   	fdput(f);
>   	return 0;

