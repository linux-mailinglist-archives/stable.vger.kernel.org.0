Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A06AD4BAF0A
	for <lists+stable@lfdr.de>; Fri, 18 Feb 2022 02:10:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230466AbiBRBJT convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Thu, 17 Feb 2022 20:09:19 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:35918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbiBRBJS (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 20:09:18 -0500
X-Greylist: delayed 128 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Thu, 17 Feb 2022 17:09:02 PST
Received: from ss11.sbt-mailgate.jp (ss11.sbt-mailgate.jp [202.241.206.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97E853B3E7
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 17:09:02 -0800 (PST)
Received: from mail.sbt-mailgate.jp (sagproxy-out11.sbt-mailgate.jp [10.16.47.41]) (envelope sender: <masami.ichikawa@cybertrust.co.jp>)
        (not using TLS) by ss11.sbt-mailgate.jp (Active!gate) with ESMTP id SKAw15250A;
        Fri, 18 Feb 2022 10:00:48 +0900
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=BE1ConOmmy8eyH6Hz1/MXAbfdkCSH/V6DgsNQR2+N3kfrnL7ENUKNnozON2nAjZFXtNGu/eEvbzQhINgkOpnUX0F8B9Ovi5FLxCZBiqNTOAjAOy1S/URnLy/kGJCwDHRtNl3I0UypEF4Q+b3WdCJlxOmEe+QOWjin5pft/MDGmDBpCXiUsfZqedX+a4r8eL5uOPIwYdDgWvSuDltLZVeW/NFe3e3M/khutwTNXhahbWN0uqBgS4+h8XryC5UyfHEcHq+WV511r7AIddSNR8rLr3Y2rm5LlS+mT8JhIeDF4HOzGoR5jzYiMCCALz+lEf7Bl1C/STIeq8tOCh5t7lDIw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=1Un1J5rsdzLuWq4M6RN2/tSztAw7KYkhRPpidmodejs=;
 b=Njpjrjv89lavZ5H32SWjbwIrfpdMuHP/PbM/bHcVVXO5L2WqfNNhDrpwGsP9Xt/LmHoprDk54LAbwortJm7ID/YrWKudaKHLSE19exVpmmwVr2s6YrwsacjGyWDC8PwNn3dzj6O/Z/ktzsyACvh/qOTUczukgKgb5qA15HesCacLUP0TNaDu5JXrLKkrmlFh+I8CESh6wsilPi7j0Y4JDr8s3UTAdfowmFCpfKVMw3Mj++I8/Btp32ChY4XOYKIGA9l3InSQPb1JlitQ6r7BXTtpwYCARSpZyxeHoUHsTVzWmUk7KgrMhcJqASds/l6W+oyIo+M54AqAP5eJKXL0/w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cybertrust.co.jp; dmarc=pass action=none
 header.from=cybertrust.co.jp; dkim=pass header.d=cybertrust.co.jp; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=cybertrust.co.jp;
Received: from TY2PR01MB3882.jpnprd01.prod.outlook.com (2603:1096:404:de::12)
 by OSBPR01MB2229.jpnprd01.prod.outlook.com (2603:1096:603:20::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4995.16; Fri, 18 Feb
 2022 01:00:47 +0000
Received: from TY2PR01MB3882.jpnprd01.prod.outlook.com
 ([fe80::ad4d:dba:6675:d46d]) by TY2PR01MB3882.jpnprd01.prod.outlook.com
 ([fe80::ad4d:dba:6675:d46d%4]) with mapi id 15.20.4995.019; Fri, 18 Feb 2022
 01:00:47 +0000
X-Gm-Message-State: AOAM532T6O9ZTYch7E/v7uAAJQSYBtickOGKTdw0IclRm1KGDdBxWTPJ
        xzV+yjFBfLFkRHhuuROgsXnfcrTIYC52dSp6rFmrlA==
X-Google-Smtp-Source: ABdhPJz+M0VRjaCCeR7/7ZCSPKWcmGd8dAs4AdblzMoGZCV5Pt/y5UEAhyDQSIdSn/1hP8FSf0cJetSUR79X0qGRDHY=
X-Received: by 2002:a9d:ec2:0:b0:592:badf:cd7c with SMTP id
 60-20020a9d0ec2000000b00592badfcd7cmr1763014otj.67.1645145552505; Thu, 17 Feb
 2022 16:52:32 -0800 (PST)
References: <20220217161128.20291-1-mkoutny@suse.com>
In-Reply-To: <20220217161128.20291-1-mkoutny@suse.com>
From:   "Masami Ichikawa(CIP)" <masami.ichikawa@cybertrust.co.jp>
Date:   Fri, 18 Feb 2022 10:06:51 +0900
X-Gmail-Original-Message-ID: <CAODzB9qKWpQ5Rn4SwHUMa8xM6jfd-EuHPLyCPFHEbTFETM4Vvg@mail.gmail.com>
Message-ID: <CAODzB9qKWpQ5Rn4SwHUMa8xM6jfd-EuHPLyCPFHEbTFETM4Vvg@mail.gmail.com>
Subject: Re: [PATCH] cgroup-v1: Correct privileges check in release_agent writes
To:     =?UTF-8?Q?Michal_Koutn=C3=BD?= <mkoutny@suse.com>
Cc:     "Eric W. Biederman" <ebiederm@xmission.com>,
        Masami Ichikawa <masami.ichikawa@cybertrust.co.jp>,
        Tabitha Sable <tabitha.c.sable@gmail.com>,
        Tejun Heo <tj@kernel.org>, Zefan Li <lizefan.x@bytedance.com>,
        Johannes Weiner <hannes@cmpxchg.org>, stable@vger.kernel.org,
        cgroups@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-ClientProxiedBy: BN9PR03CA0338.namprd03.prod.outlook.com
 (2603:10b6:408:f6::13) To TY2PR01MB3882.jpnprd01.prod.outlook.com
 (2603:1096:404:de::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 2c823158-508e-4b93-e907-08d9f27a1985
X-MS-TrafficTypeDiagnostic: OSBPR01MB2229:EE_
X-Microsoft-Antispam-PRVS: <OSBPR01MB22292B6D1935A375A027245CD4379@OSBPR01MB2229.jpnprd01.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:751;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: UNzZf6nW4+OSudPjp5LbOdYK3dLsNpkY2zH+NetfHtaI8bmXGHEhYYmG2BnyTr4aOwzrOQZ2kaXRf2upo8UH+sRWmDJpWneZ1vk7W6sjg/V5lp07j+3lmIWclM6hclpeBIVf7OyqzyKXJv96Z/ykcIGVDCVi0HwkYT6juCJqwkfZBK4Kk7cY5jQEwviiCpl2eaVngD52AeJDIDY/i7DLj9aNZyLIOr6HNIEcVV93z18szs7nidjpiGdgtNlIaSM1zLvD6Y0J6IrAbugsBOsM8qErblDYAsQhmfYJOy+xk0NsNtCmhyHnnbCYp2Z1tE85mC5ycH1UqIayhdC7QoBTdEB8VtxoOWVZay9Y5uPzk+f2Lb8y38RRyB9Z8Ips8jII6UHVuHDiE0VaccJig1Opwp5gZCh/qQWCtsCpttyCM8WyQbsHe2vFcZYEWw4rUpVFWpV8iSe1UwO5uGJDBZ8FIk2wSdd7BdYDewd18DyvtHayriTJbEOqknvD8Lo34fdJcrIeyKZBakndlGsRy2NuXLy2x2i7nAr/wpIMt9e3F1/MIguvs3PGPCqLokKfAG6lE40whkwpBxLOkBeIZwxoDQGQLsbi+y0TOeTNPvEagHHrsJui/YBd2CKTCxakbVmrjKAkSUkL+/C5ffePO/qx1u5h9MvITyXDX+2UbBICArdY1C0y1Ym1YJncyE6V1IPsRqt81YalRGGrvF40oMTmP9yXQaI4Toi2xDPdzBSNMECdk5u7o2rBpQ7Kd+/U2C2N27xBx6IDSJhjQ7KZrEv80Q==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:TY2PR01MB3882.jpnprd01.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230001)(4636009)(366004)(52116002)(53546011)(55236004)(82960400001)(8936002)(6506007)(9686003)(6666004)(6512007)(6862004)(4326008)(66556008)(8676002)(66476007)(26005)(186003)(66946007)(38350700002)(5660300002)(38100700002)(83380400001)(6486002)(508600001)(86362001)(316002)(54906003)(2906002)(966005)(55446002);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?N2lkZnh1V3lSR2IxRWNxSGlvdExHbHI1NDBvS29haWdSMmRiWGlmK094ZzRu?=
 =?utf-8?B?YTRUVGJZdTIwb1RmdVM0QWFoQUMzZ2Y2ZlNqcWhrb0JIcUNXeGIycWllU2RL?=
 =?utf-8?B?dkVSTkhwTmg2VGZxVktWSmdNdnhyV2NQTjIxWU1STHExNGNEQVdVeEl0b3hN?=
 =?utf-8?B?cmhVd2liY1prM3VvQWFtQTJwZVdhQURLQ3ltMEtWdUlUMjMwUzBOYkQzUThq?=
 =?utf-8?B?NU9FN1ZqcVZROG9NZXcxNEZqZFhKNGJObXM3dGpMUjQxaWxLWVVRckUrN2U2?=
 =?utf-8?B?VU1lc0J0VFBlNEVnTFppcURObkw1ZHd5YkwrVHhWUU8xZTlmclZNY3dsYUNr?=
 =?utf-8?B?NnJGYXVITlJsM2lmMmpId3ltam5sN0w2WTlzMEZ1Qk1XcW96MnZJcSs1SHh0?=
 =?utf-8?B?ZnV5SGJoai9DNS9Idm9QS3JIZzFoYnhWNzlmYUROWEFJcjZQSkJxM3FGRjRC?=
 =?utf-8?B?MkNTVGx4QklkZ1JBZCtvczFKbmVuVzc0Ny9TaXg5cHRsNEtRSyt5eGhDbFRv?=
 =?utf-8?B?cGJaNVNzMXRWblY4TUZSbGQ4Z25SZkU1Z3lCM2RRYU1RQWFOaVpGdDN3NGZL?=
 =?utf-8?B?cmw0aFlUdTl0WGJCNzVkSnFUemdTcEVSUVFrOUEzZ2JFVW5ENzhSdU9zMmta?=
 =?utf-8?B?eTlsdFNZQWJQditBVTl6d2lMYnM0UVluTUJVeGxWaFR4bHZHcTNkL2JXMTdx?=
 =?utf-8?B?NTMwdHJNYUpNREtyaGxJV2xheTRUbjhBcldCQU5TMDUzWG9ka2hwamlBT0ly?=
 =?utf-8?B?MEpuK0ZRNENaQmFRbmlxMUZZSExaMlJxbm1YcnIxUmtIRmtiTUpLamxQSmR2?=
 =?utf-8?B?Z0V1R2tWTjRNamN1ZUp0Y0V4cW4rUGptUXF5TVp0MnpveGN2S1NCcldCRkVp?=
 =?utf-8?B?M08zVGRLaTQ0aTRJSTVONkFTcWhvR2xTa05Ta3VYN052c1FEc1JLb3Vsd0Nt?=
 =?utf-8?B?dy9NdXVvcWdIYVV2b0U5cGd0UHpZZDJVc3dVVHVtYTVtTlJXQkhpTkdST0N6?=
 =?utf-8?B?dTdHdGc4djBZaGtOWGhjUnpxcjZEcENhRVVvVEplZXhxTDM4TjF3cVduc1l4?=
 =?utf-8?B?KzFYMGxYRWRTZVlNNktTbWhPYkxrSFQxRmQrZDA1OWRhdC93eUFtL2ZZS1dR?=
 =?utf-8?B?RzlhLytjeVd2UGV0WWN4ZjN2cWQ5T0hYL2dyUjg0N2lhK2dpYzFPMHkxU0k1?=
 =?utf-8?B?eFRBK09sMmFVQ3RnNW9QeEovaWw5T2ZoMnJQdTlmTExKL2dGQ3ZKMzVlbDRI?=
 =?utf-8?B?MUMyZ0ZhOGMxWkZkSlpXYUJzdEU0SGx0SmtGVXk1ZTh6YllGQXUxOUYwcmNP?=
 =?utf-8?B?M3ZUbEJ2L29zS240NGNDaGh6VEg0ckJ0RC9CeUE3c3NVa0ZTQ0dWRW5DWmVv?=
 =?utf-8?B?R000a0N1MmJhZHhBTU5yRmVtaENVbXptRzkxZ1c4VngrODZuQk9oV0RxVmZt?=
 =?utf-8?B?aHQzd1QyaGVPVHdBenV3Tko3dWhwYlliSjRibEJmdmswNlloZzFGZ2l2ajJn?=
 =?utf-8?B?UHRUZExRSjdCcGd0S3diRWIrVTZzem1RRGFXZE5YdldEc0kwQjdjb3dpcEpW?=
 =?utf-8?B?MjdHZmRiNjUyRVZLK0dnaVlsc1JBaENQeUtEL0hydnFaejBlTERsVGNUTHRC?=
 =?utf-8?B?NDR2OFBseFBoUk1JLy85aFVkREpsRFRRSXk5RkE0bjRVTXN0MS9QNU91NFFx?=
 =?utf-8?B?RlM3MkdQenJxdWRiZFNqMnRqTGtYN005cjd4TmJSeHQyZDZDWkhGYzUrc2hP?=
 =?utf-8?B?SzFtNVcwdkNqTnVybW5XcUFJL0ZSQ0ZyQ3Z2UDhYV1RpWkhhaFpWMi9EVTdx?=
 =?utf-8?B?STFrdmhhbUk4ZzFZMzhVYmF3T254S1gxSHpYMzdVSEt0WGhZcUdRbTFnTGo4?=
 =?utf-8?B?eU1WeGhQZjJFRWNjbDdZazZ5SXg4YUFnSlMxU3ZDYWpzN2w4aXBRKzBqZ3N5?=
 =?utf-8?B?bHVjRXR4TTl2cjYrZnlwS3lCRXlWTDlaMkJIVEt4ODEwNi9IbnI3TGRJM1hH?=
 =?utf-8?B?Wjl0WXVrZEoxNDZjVUFrY1EzN1hrdTJFTlI0WGhVMktMRHJuUDJrTkUwSUNO?=
 =?utf-8?B?Qnh4U3hmVTQ2bFlFT3hkQTkrL2wrREo3bHZiT0FhdnVQVkYxUGhpNWN2ZldP?=
 =?utf-8?B?eWxDWlMxc3ZIV0dZYlVvSVFVd1R5eC9TK3lHN0Q1RjBKcmRkeEZ0V1VRK1JT?=
 =?utf-8?B?dWV6RzdKTnpoSFVtcE9lM1VsdjBFMS9Zekp5dEF4QWVKZzlaUHlZRzlad0dZ?=
 =?utf-8?B?eDg5Y0JHeTNPWHVzQzcwQ1phL01MOFNmbUF6anFRb2owaGNMVU5JT1V1QUVw?=
 =?utf-8?B?RUxKb2E1L3lmamxkRWc4MWJtSFJsVkt6bVNrdXMxenZJaHQ1dW1NQT09?=
X-OriginatorOrg: cybertrust.co.jp
X-MS-Exchange-CrossTenant-Network-Message-Id: 2c823158-508e-4b93-e907-08d9f27a1985
X-MS-Exchange-CrossTenant-AuthSource: TY2PR01MB3882.jpnprd01.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 18 Feb 2022 01:00:47.8555
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 72cc4624-32b4-4dab-b80a-8563e559bd82
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: vsMMjfOQdKXXp4VCFeV2FU1T6iQgfFfHPE/0jUZRKbwAWKTiX8tQVNhNpdK6J8fblhX4uFYf+hAdmogj+fsgmgzyLxMp6Pi5VZCROBARDBGM8Q2+QYNDohwYYn3HCxAA
X-MS-Exchange-Transport-CrossTenantHeadersStamped: OSBPR01MB2229
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 1:11 AM Michal Koutný <mkoutny@suse.com> wrote:
>
> The idea is to check: a) the owning user_ns of cgroup_ns, b)
> capabilities in init_user_ns.
>
> The commit 24f600856418 ("cgroup-v1: Require capabilities to set
> release_agent") got this wrong in the write handler of release_agent
> since it checked user_ns of the opener (may be different from the owning
> user_ns of cgroup_ns).
> Secondly, to avoid possibly confused deputy, the capability of the
> opener must be checked.
>
> Fixes: 24f600856418 ("cgroup-v1: Require capabilities to set release_agent")
> Cc: stable@vger.kernel.org
> Link: https://lore.kernel.org/stable/20220216121142.GB30035@blackbody.suse.cz/
> Signed-off-by: Michal Koutný <mkoutny@suse.com>
> ---
>  kernel/cgroup/cgroup-v1.c | 6 ++++--
>  1 file changed, 4 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/cgroup/cgroup-v1.c b/kernel/cgroup/cgroup-v1.c
> index 0e877dbcfeea..afc6c0e9c966 100644
> --- a/kernel/cgroup/cgroup-v1.c
> +++ b/kernel/cgroup/cgroup-v1.c
> @@ -546,6 +546,7 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>                                           char *buf, size_t nbytes, loff_t off)
>  {
>         struct cgroup *cgrp;
> +       struct cgroup_file_ctx *ctx;
>
>         BUILD_BUG_ON(sizeof(cgrp->root->release_agent_path) < PATH_MAX);
>
> @@ -553,8 +554,9 @@ static ssize_t cgroup_release_agent_write(struct kernfs_open_file *of,
>          * Release agent gets called with all capabilities,
>          * require capabilities to set release agent.
>          */
> -       if ((of->file->f_cred->user_ns != &init_user_ns) ||
> -           !capable(CAP_SYS_ADMIN))
> +       ctx = of->priv;
> +       if ((ctx->ns->user_ns != &init_user_ns) ||
> +           !file_ns_capable(of->file, &init_user_ns, CAP_SYS_ADMIN))
>                 return -EPERM;
>
>         cgrp = cgroup_kn_lock_live(of->kn, false);
> --
> 2.34.1

Thank you. Looks good to me.

Reviewed-by: Masami Ichikawa(CIP) <masami.ichikawa@cybertrust.co.jp>
