Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3FD255748B
	for <lists+stable@lfdr.de>; Thu, 23 Jun 2022 09:53:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230472AbiFWHxF (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 23 Jun 2022 03:53:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230449AbiFWHxE (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 23 Jun 2022 03:53:04 -0400
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (mail-bn7nam10on2048.outbound.protection.outlook.com [40.107.92.48])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B6BA11DA62;
        Thu, 23 Jun 2022 00:53:01 -0700 (PDT)
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=QTAKZxYaIHtTxX7cec5pvHChAdkUIAx4M2tbnCdeCvKuzdyaLbTFie5uZ8dJNIDRDn5jv9LU5y9nkQoNWzcgH/SRwzgy/0MWl7eB2Z9clwhG0kMsXdYt9p6vGjcKHeFiGxGVqKnDn5AIycDqa9aEs8xThPVUtIVIwmIuLbef5eu+9c7tO1+IFguVph4x39JhfJTWX903UpCVv6aZu6SReTqdNYTdANCmuaSWPuNFAW0Q54mV+70H07Q2DiuVCNBlQ/Km5kgX0n/Ur159Vmj4IgMKaQEplyliOv+cF2RzK0PTMVRcs/BoH/kAv1ZBtHtFRIXzM1n0jEj+XkAsOLuKSg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=6iBadxwr7rqv96X1keHEVExLjaeD9gyZ9BuNYlfQaeg=;
 b=a+HHq4PliISuYsACNu605Rwa++PcfKJkxV05G4CumX40h5vc+wmSl5ZP8+nnt54Uoc2oET23EUe3gKWZ6cQ0+aaiRQ4VxvAgBa33CahPfhBWcpVNjDrZ/eZjkpqusohedU3IEX0PaxRf+Am5q87QFD+WxrV2o79wk2cbQ/op+7WgQ1902OfDbXmcFW6hijZAWk7z53UwBdMtK+LPtlc8eXCaA+micwRrb7ujfZ74uAxTY4FAbZYa1j2UmmeAiTcLnSgMeF/oXridO6t69/3TTCpWQ4VX+Nz1YX7tpXiyO7Q5Zn6g1cHvqBcWNwNyXB2IqZxkb9FPfIMpMp3CUPVtCA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=amd.com; dmarc=pass action=none header.from=amd.com; dkim=pass
 header.d=amd.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=amd.com; s=selector1;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=6iBadxwr7rqv96X1keHEVExLjaeD9gyZ9BuNYlfQaeg=;
 b=GOxws2Y/T47tCUIQrQff1w1ygpjofHUkUSeDkXAKJINtnKcrsUeZFWzzEQ8ibPTYK12YvcGpy/aPuyKqPwty78LZ3s3V4eS8HLTfabF7kZPZtRsEEEXjjMr7oAxelx+vMFHdztxOz4oed4eozJAR4H1Lqs1JAqDrass226/jvj8=
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=amd.com;
Received: from MW2PR12MB2506.namprd12.prod.outlook.com (2603:10b6:907:7::12)
 by CH2PR12MB4245.namprd12.prod.outlook.com (2603:10b6:610:af::15) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5353.16; Thu, 23 Jun
 2022 07:52:59 +0000
Received: from MW2PR12MB2506.namprd12.prod.outlook.com
 ([fe80::7567:d120:4673:e57d]) by MW2PR12MB2506.namprd12.prod.outlook.com
 ([fe80::7567:d120:4673:e57d%5]) with mapi id 15.20.5353.022; Thu, 23 Jun 2022
 07:52:59 +0000
Date:   Thu, 23 Jun 2022 15:52:38 +0800
From:   Huang Rui <ray.huang@amd.com>
To:     "Su, Jinzhou (Joe)" <Jinzhou.Su@amd.com>
Cc:     "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "linux-pm@vger.kernel.org" <linux-pm@vger.kernel.org>,
        "Deucher, Alexander" <Alexander.Deucher@amd.com>,
        "Du, Xiaojian" <Xiaojian.Du@amd.com>,
        "Yuan, Perry" <Perry.Yuan@amd.com>,
        "Meng, Li (Jassmine)" <Li.Meng@amd.com>,
        "Liang, Richard qi" <Richardqi.Liang@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] cpufreq: amd-pstate: Add resume and suspend callback for
 amd-pstate
Message-ID: <YrQbxvyl6ZT2T3wh@amd.com>
References: <20220623031509.555269-1-Jinzhou.Su@amd.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220623031509.555269-1-Jinzhou.Su@amd.com>
X-ClientProxiedBy: SG2PR02CA0088.apcprd02.prod.outlook.com
 (2603:1096:4:90::28) To MW2PR12MB2506.namprd12.prod.outlook.com
 (2603:10b6:907:7::12)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 54147c20-f31a-4bf4-d2b3-08da54ed643a
X-MS-TrafficTypeDiagnostic: CH2PR12MB4245:EE_
X-Microsoft-Antispam-PRVS: <CH2PR12MB4245C53F93A172A611D78730ECB59@CH2PR12MB4245.namprd12.prod.outlook.com>
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: Fh5JubwY0s0cjF3B7AkjWijp/7md1q2FTyU5E6xD/YsU+HwFd2EixXrhv+bhN8mLiis4k9y4XHdeucdOcCd9JQLAbT0HcATO0WaK/3e6C5iiDSRpbpDuSgIc37Ep5U7Lc5NgdR0XyCty/ZZWdw3mD9EDdr1ao80sOuVY7Bi/DMWuRV8004LN7a5kRRAU8BBBO/2CrpWWpVgLI7My6GW/Ewwr+DqhHcozJ83ek9QcFUqcZvv3CR1s/06q1TAjKrMzO1ixt2zEFXrjiBHWNltkgJeZhiYGwQphTfkd/AfJibg+gnshDWBC+BKoLzi6c2TBs+wig6Rk8sowMY5zxzwURofmpzxsxA/sR9ThYxBBmKV9lRBvHvzMw1ejJNL4j1FNl5LENC89TQiuJL2IuMblNxwL0GUtFaTuj6v+dHGDuRoZK4O7p9auBMF+VceYPOa5DC9yJfauda9qcWdXINK+ykB+o99TYSeuAAZ3gKWf74IcEZRAwe2gXK9kZDTneBbovDGpuOhYzs3Rc+zCjQv2Nhlt4Q+6tp4vjmER8ICcBGWguvD6H8JUOPV5NNPilpLbzbaz+m+vFODk3BqUteFVdREFMqrNKGQDNfuc3ETm7Me8Qg7kj7ZnxWqYcl57crpsWFSSVScOPPqo/Q7S6PMemAr+or70XtmcXjnQGBiSU5iu94pYc/vXe+hBxKBdqzQLJLC02YRYtonn1kwHT6/uGQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR12MB2506.namprd12.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230016)(4636009)(376002)(346002)(366004)(39860400002)(136003)(396003)(2616005)(4326008)(66946007)(41300700001)(186003)(83380400001)(8676002)(6486002)(86362001)(316002)(66476007)(66556008)(37006003)(6666004)(36756003)(15650500001)(6636002)(38100700002)(2906002)(5660300002)(478600001)(8936002)(6506007)(54906003)(6512007)(26005)(6862004);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?eAldg5vQ0DRIitOI+Isw94yNIZvefpj+CulfceJBl4uRvTkCeXTZHzrL+960?=
 =?us-ascii?Q?N089JSsDbE8hOj85KH2eU8fFdfMNph38WWmmRgITGk29azp56ldM8klmK3fQ?=
 =?us-ascii?Q?2YDDGeUA+o4kV9O6FRFFm9ER4jGqRTXjlomRp6ElMyOdiKyHKun8+8RBkeBD?=
 =?us-ascii?Q?lnZxYSXIXoDycd1BGUnecJzW54AM7xIbuxrrbenGl0JJLb34mf1Cxm1Ok5Ad?=
 =?us-ascii?Q?j/30MHUFZV/xy4uW3v/k539NuucncPvA9u8ml/cg4AE+D2Ja6okKfOoZUGlo?=
 =?us-ascii?Q?1wRkgtWs9fa4BkwPQ9DdSeZs7ZSnPo6kDPJfKpPKYq1Wbv4kRXNb8xdZhBBC?=
 =?us-ascii?Q?sZftN1MBdxTmDMXPMVAYgtPXDvWxIGkaOhvymZOo+XSojPwHQ/75WWzK7MGd?=
 =?us-ascii?Q?NZaBoFR/Qa1mgFA/Y4adz6G1PJkYSiVxTBVQxxXCv8gMpu9zALIrIIdB96fG?=
 =?us-ascii?Q?qphMlFEKyVoMcqQ1dTLC9oq83cgbIhBmYYmmhzxX4VzqY2PliQNe9ajyFSZ9?=
 =?us-ascii?Q?vPLy/AvrxJWu85gp+qvbncfWKmKvXKCM2vOYihcQzCs7DOb8IbS6vI0/iFhG?=
 =?us-ascii?Q?rQ4LsWQC2yanE0mQ49Bdv+tamco4k2CYZlzAtU6GdQ3GpyqJnh5PaN1MVF/7?=
 =?us-ascii?Q?PxbU0nnjh7RC2J7MRgSaGk2dw7vtXONPdtI+n1wNSYlD8UopA9By0eBgLXg4?=
 =?us-ascii?Q?CRIlg2+dl51EE3uy+3/ybOpDfpoX7tM/EsGmXxeHF1OKgtBnVS2/7/bLo7wJ?=
 =?us-ascii?Q?sTZzF9AadZK+NsyVeTCt1gvNMYWqs1KJTGXe3aWtLdRV6jPPGdBPQf+aEAdq?=
 =?us-ascii?Q?uSYKcfxQ0LjLL/ld4A68kykjSmDYg6j1gsPG31J1eGcqDIPbkD9S6biTZLDq?=
 =?us-ascii?Q?Uw5YvwP2gYeqRdrgPQTndhri3ZSmA/W+rMFPuXeJedkh8FYTTIrYzPANPurc?=
 =?us-ascii?Q?nVUoCufRBuNHCUQATh+AbfcGiGkY4eb/zUg+uKczGA5+fjTlxFq9OvW5NH7l?=
 =?us-ascii?Q?FudREh1tGLt71TVu1ErpoMHM/bEOTUW4mo+fhJhz2pfyJt3Lgblme0nql1Pg?=
 =?us-ascii?Q?53zK8kzelPxnw45Re9Rj8UaUwsz2i1r8HFqSowrTlmw4wGQ0JkronJACcRza?=
 =?us-ascii?Q?dGJ5m+cNb4Tf2JxJ4lE7MwLTLaHp7RhPYRTD5HG78NH7CfKVB2TPE08esidY?=
 =?us-ascii?Q?KY0wea9UvMTms05PBu8Fmhb6WPzN0tSOZOFxRzlzTtaBcu4xq9ibwKSCMj0z?=
 =?us-ascii?Q?1Zkci4e/Fq+wn2zcUXXhMXJVIZJHUYR9Z18ri+U0IIIZNj1iyFXSmcd1PkPj?=
 =?us-ascii?Q?MSMhKTto2XTKr0wgHPgmiXKj9jApR4VIafLYidru7FDl1jS4RIVschpIwFUJ?=
 =?us-ascii?Q?LcJzhQk+PLn2UWsXp3P2m24I9FIa0HUPEmGeKMhy6WYLePtxjldgCKBMr8SC?=
 =?us-ascii?Q?XIqixeOYRoRHMdlwbGB+oH4cg8ppyrU7+C9uKE608BEbzOweojNZH4PmZayc?=
 =?us-ascii?Q?oNFL0Pf5fwTeb91ZCHqYKjaYfky0MUUwmeVm6jkrp+czc5xrYiazNeYkmP4g?=
 =?us-ascii?Q?ydrlvTT5bTAJgbVL3U0vqf/9LzxQvDJKcoiQseGMZONZvPhsiDMAxBwMevSN?=
 =?us-ascii?Q?hJ8Wg3g9xG8YAFqDRCiGweKc2nDHXSgu2qIEj6tYuWRrjegzH4issetZAAwE?=
 =?us-ascii?Q?lhukcR+e9IeMcvEs5fKcly6ps68mCjRSGcusQNvQZfokasJYTO6zv5e6GZ8e?=
 =?us-ascii?Q?yv8ruc6uJA=3D=3D?=
X-OriginatorOrg: amd.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 54147c20-f31a-4bf4-d2b3-08da54ed643a
X-MS-Exchange-CrossTenant-AuthSource: MW2PR12MB2506.namprd12.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Jun 2022 07:52:59.3936
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 3dd8961f-e488-4e60-8e11-a82d994e183d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 9qqsSnIdKsxLz2lGLePa/CGpmFFBP9ol6AbZDEHkWdj112eWAe6AQzGxpZ5kiXMah5R/jVXGcrwf8twtmhqGnA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CH2PR12MB4245
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_PASS,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 23, 2022 at 11:15:09AM +0800, Su, Jinzhou (Joe) wrote:
> When system resumes from S3, the CPPC enable register will be
> cleared and reset to 0. So sets this bit to enable CPPC
> interface by writing 1 to this register.
> 
> Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>

Signed-off-by: Jinzhou Su <Jinzhou.Su@amd.com>
Cc: stable@vger.kernel.org

You can add one line below your commit description to Cc stable mailing
list. And next time in V2, it's better to use subject-prefix optional to
mark it as v2 like below:

git format-patch --subject-prefix="PATCH v2" HEAD~

Other looks good for me, patch is

Acked-by: Huang Rui <ray.huang@amd.com>

> ---
>  drivers/cpufreq/amd-pstate.c | 24 ++++++++++++++++++++++++
>  1 file changed, 24 insertions(+)
> 
> diff --git a/drivers/cpufreq/amd-pstate.c b/drivers/cpufreq/amd-pstate.c
> index 7be38bc6a673..9ac75c1cde9c 100644
> --- a/drivers/cpufreq/amd-pstate.c
> +++ b/drivers/cpufreq/amd-pstate.c
> @@ -566,6 +566,28 @@ static int amd_pstate_cpu_exit(struct cpufreq_policy *policy)
>  	return 0;
>  }
>  
> +static int amd_pstate_cpu_resume(struct cpufreq_policy *policy)
> +{
> +	int ret;
> +
> +	ret = amd_pstate_enable(true);
> +	if (ret)
> +		pr_err("failed to enable amd-pstate during resume, return %d\n", ret);
> +
> +	return ret;
> +}
> +
> +static int amd_pstate_cpu_suspend(struct cpufreq_policy *policy)
> +{
> +	int ret;
> +
> +	ret = amd_pstate_enable(false);
> +	if (ret)
> +		pr_err("failed to disable amd-pstate during suspend, return %d\n", ret);
> +
> +	return ret;
> +}
> +
>  /* Sysfs attributes */
>  
>  /*
> @@ -636,6 +658,8 @@ static struct cpufreq_driver amd_pstate_driver = {
>  	.target		= amd_pstate_target,
>  	.init		= amd_pstate_cpu_init,
>  	.exit		= amd_pstate_cpu_exit,
> +	.suspend	= amd_pstate_cpu_suspend,
> +	.resume		= amd_pstate_cpu_resume,
>  	.set_boost	= amd_pstate_set_boost,
>  	.name		= "amd-pstate",
>  	.attr           = amd_pstate_attr,
> -- 
> 2.32.0
> 
