Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 88FD865C3B5
	for <lists+stable@lfdr.de>; Tue,  3 Jan 2023 17:19:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233677AbjACQTW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 3 Jan 2023 11:19:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231229AbjACQTL (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 3 Jan 2023 11:19:11 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D412C1A0;
        Tue,  3 Jan 2023 08:19:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1672762749; x=1704298749;
  h=date:from:to:cc:subject:message-id:references:
   content-transfer-encoding:in-reply-to:mime-version;
  bh=6ICRchekVibNKGEboqQve45ZohoJ9u/XxccUeVpILZY=;
  b=g4Lx0NGT8zyyGIq8Kh2fVSvzcYhpuSXaNEgo6B6zl18ZLjwxuks4AO6Y
   0R4WSw/u4DKWfJBRUigcxsb7XDmtuyyfeGkqXufEG4BvI0aeH6Qs2hceL
   3k6wMho/bief8G4e2RZR3CLf5ZNUvwc5Q46kVT8fZvG4ChOuC/b87m8Fm
   n8y6qsz4LE4SqbOGNywkJyNOAgZLS8C3mEswyQXZEeGLHX8iXLMrdy34V
   upKFR4Odd6r5xXsSJ9shCHK2CQA2CzEhZm+xBIcyOrhRzbtXXkyHO6qGG
   Ym8EuG7L3eo9CFb4Qy0GkQwrtTK768dyFtarAXaxQd/S2d3yfNkM0CbMK
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="301373904"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="301373904"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jan 2023 08:19:00 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10579"; a="648264214"
X-IronPort-AV: E=Sophos;i="5.96,297,1665471600"; 
   d="scan'208";a="648264214"
Received: from orsmsx602.amr.corp.intel.com ([10.22.229.15])
  by orsmga007.jf.intel.com with ESMTP; 03 Jan 2023 08:19:00 -0800
Received: from orsmsx610.amr.corp.intel.com (10.22.229.23) by
 ORSMSX602.amr.corp.intel.com (10.22.229.15) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16; Tue, 3 Jan 2023 08:18:59 -0800
Received: from orsedg603.ED.cps.intel.com (10.7.248.4) by
 orsmsx610.amr.corp.intel.com (10.22.229.23) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2507.16 via Frontend Transport; Tue, 3 Jan 2023 08:18:59 -0800
Received: from NAM02-DM3-obe.outbound.protection.outlook.com (104.47.56.46) by
 edgegateway.intel.com (134.134.137.100) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.16; Tue, 3 Jan 2023 08:18:58 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=ThlwmwbvjBUkWkqSERNC1QQq/ZV+mLDwGGO1pqMVmqPJwUZyHxN40pp4eUxPJFzHbZSnM9m8nI+Hd6SS+P8XgpA8zNZi6qxJ6LGtJtF4SuElC/F1QK5VkYwF7gVJ8/8LiIxAdc12tM4/G2r6qdQ8fSblwZCXg0Bo2dblLHs1ZHHQMOI/SZOlyJmV9FFuVkrwTsxUE1I/D+0YiGTfksqYXvlDpeeS1A7UZOP5DYj3DCnq4R85Km5bp/QcT5TvWN4OhEpIp0HVAyw+B/xGw3ivgCnB7nbt273oH5g8ifyTB+8S9vxEs6m9MwapFOAMNLh9qi2VuTOxBYLJvOShTwamXQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=7qf9l08sXI2J1lHUsaQpLd83HMuKplOeVFlVAHZT/04=;
 b=XH71oe4l5h8jku6u78wHLYQmcsA/oSIHBJQRgRXbstz6iNMefkJ84poI+rr+ioAgvo3O0QF0ExzVVaHIEcX8fY+bk7sOe13kSuQUFVkYYDNCwzV92PfTamRwf+fHzZ5vRPMlb5pfS5GDG8cKMJmQVxrNqxRnaEYcDSJBQey1LulpHyXkAw1Lw7hKPknnPQDzVD3BkBgKgobrDdl18nrmarRTr9RKWL1j3EByHXyobmFaro5TMcXhc0VL9waIPZLB8zGBjIFAfkrkin7p81BmjqBCGrrPr12l1XlLN7UHsrWszkhCxfJGL5wa59UOy6d06t6ISONQ8pbbjST5u2H7ew==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Authentication-Results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
Received: from MN0PR11MB6059.namprd11.prod.outlook.com (2603:10b6:208:377::9)
 by PH0PR11MB5951.namprd11.prod.outlook.com (2603:10b6:510:145::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5944.19; Tue, 3 Jan
 2023 16:18:55 +0000
Received: from MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808]) by MN0PR11MB6059.namprd11.prod.outlook.com
 ([fe80::499c:efe3:4397:808%8]) with mapi id 15.20.5944.019; Tue, 3 Jan 2023
 16:18:55 +0000
Date:   Tue, 3 Jan 2023 11:18:50 -0500
From:   Rodrigo Vivi <rodrigo.vivi@intel.com>
To:     Alexey Lukyachuk <skif@skif-web.ru>,
        Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@intel.com>
CC:     <tvrtko.ursulin@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        <intel-gfx@lists.freedesktop.org>, <linux-kernel@vger.kernel.org>,
        <stable@vger.kernel.org>, <dri-devel@lists.freedesktop.org>
Subject: Re: [Intel-gfx] [PATCH v2] drm/i915: dell wyse 3040 shutdown fix
Message-ID: <Y7RVavxGE6GDLQXJ@intel.com>
References: <20221225184413.146916-1-skif@skif-web.ru>
 <20221225185507.149677-1-skif@skif-web.ru>
 <Y6sfvUJmrb73AeJh@intel.com>
 <20221227204003.6b0abe65@alexey-Swift-SF314-42>
 <20230102165649.2b8e69e3@alexey-Swift-SF314-42>
 <Y7QjsNBYKumzEvBS@intel.com>
 <20230103190920.754a7b2c@alexey-Swift-SF314-42>
Content-Type: text/plain; charset="iso-8859-1"
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230103190920.754a7b2c@alexey-Swift-SF314-42>
X-ClientProxiedBy: SJ0PR05CA0043.namprd05.prod.outlook.com
 (2603:10b6:a03:33f::18) To MN0PR11MB6059.namprd11.prod.outlook.com
 (2603:10b6:208:377::9)
MIME-Version: 1.0
X-MS-PublicTrafficType: Email
X-MS-TrafficTypeDiagnostic: MN0PR11MB6059:EE_|PH0PR11MB5951:EE_
X-MS-Office365-Filtering-Correlation-Id: 0b168f11-eaab-41e1-fff4-08daeda635f3
X-LD-Processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: vuFmXbxzrUfQt+UBCE4zuqNz0K5MG+1M7kdholBmuXLmIrcy2ewg24Vgif9ZHaWQzK8N0NW5eykZc9WO/QB3kFUyi9f8lxemHNHKMZv8rwx6p8JDhOgOGPOXNwr9C7PgJBWjaOILsmvq/WJ6P5ZcweRqzwn75pb6PfOfSY/VGzJMxafrtAqjLQGBHSGZJXFGIFhVQfk+SxQYCt6Ywq50/v2/GaWsglsvQ6mZJRuCamIv5HJ3wk6nuF2scbvK0pNYLyZhudNCa66cRcfkfuC4DO/sFZqIWB4h9gsthRrSA+Megk30KRXMYHZ6VZysaiAC/rP2cAyyBVz10tP6sALofsgrMZ/pvHHPQn+dBqHfXa+1OgkhPsBU82RZLwR4gNIWpjyQhOz3tikT2z7KUSurq6fD446HEXBN80JPxTiwHEiF4vNh+HVIYSejPIOvFupZbxb7Hla5GI4b6U26dvnHx2AGbNUKdyD4cd52FJoe1zoB8Yl2FQCfDDr7Uqg7Hv5QHgDlX2RJ/tcV2pLhcb/v0s6pM5noWheUcxyCIZzVRd2+og0lokzlRCq/2sDffxHEfnaGof4Eqa1qY6QH88uvONxvGGp9pVRnHu6NUVK0R9Zap+ChVY8JWWvS8+Lx+8k7brzM4ukhFHU0ERjjYpjrlDU4KTo/igy3NRKiwUu6XIWhftdYd4rFNCW553UqEGKXIjiwFlFnE4pvYt350uTuW44C1EgOAjvFcJJ/RHTmlrLqKHLFuF5gCbgIRvdVmlx/Lwco0+NJUmoloKkLAmRi9A==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN0PR11MB6059.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(376002)(366004)(396003)(136003)(346002)(39860400002)(451199015)(5660300002)(2906002)(44832011)(8936002)(4326008)(8676002)(41300700001)(478600001)(30864003)(316002)(66476007)(66946007)(110136005)(6636002)(66556008)(45080400002)(966005)(6486002)(6666004)(26005)(6512007)(6506007)(83380400001)(66574015)(82960400001)(186003)(38100700002)(2616005)(86362001)(36756003)(22166006);DIR:OUT;SFP:1102;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?iso-8859-1?Q?bpAyyuKBnVJClfDxPAhDcr2A+Uvy/sPXfv+4KurJxEFeurQ1+mhcPxbSEd?=
 =?iso-8859-1?Q?Odu1wRR77jU6HM2NefJ4VqgXBGNuKjcWdGpvgsKQMQdVsD/xPHLrPAeRHa?=
 =?iso-8859-1?Q?rdtfWzEb/VDTeaP1bQ3RzMEz3PEHzglbx0byA4pqwc5x3D2+a5gysMF4BA?=
 =?iso-8859-1?Q?7ktHMEpVDeuYZeLMvvC+2C4wLXQdmTWnTBT3+99G0JcvlXgdSToQyf1nUr?=
 =?iso-8859-1?Q?ggNW8njE0SEKS0HYW8EgXky8xfvWOSHikV8vUNcC0lkPtq8JHtgKCqLg+I?=
 =?iso-8859-1?Q?JqX2E+qvTSZV8ySs1wAo9+hSZplUY/CdZBhwdDNy2+/ZARz56AzrI602h4?=
 =?iso-8859-1?Q?Dq371MdfcNWSQUlDLLOOR0qMbdZeAyQkw9Lb7eBc8Xd0O3GulOiKVuXqpQ?=
 =?iso-8859-1?Q?KUmJosZczA+P9ltbETcI8Av/LQZ0HIThY+7u56Fy0Fo+YRRG6R/ihkBtuP?=
 =?iso-8859-1?Q?obG9bt/UZJix5upFmzjBqxi3u5tqUWDb99WBlIoZ+toi0G2gAt4EbGQXIt?=
 =?iso-8859-1?Q?VyYeTOLHF2wnd+PcDNvTrEmR7zTWDAVL8A7eQSrc4LLyi4qr0IoLzrPOl+?=
 =?iso-8859-1?Q?ThMNV0LGnkgQk0cQ6Yrh3oYUQM7FPaTh/vI7k3F1DImq8JrFjY+ZCrriWL?=
 =?iso-8859-1?Q?qdXF6Dd7l+6R7Meu6HBHKeGnEOOVP/tifDi2TPHeCaCDXQUFgmQi0HrQVE?=
 =?iso-8859-1?Q?CqsXn4rMO5KrL92tS/HKMyc6wKtfg5Fh4zydIg64O2cmx/MrWxmFn1RMb2?=
 =?iso-8859-1?Q?5fi0kgRtVISqF9uLUiXabzjzZnqkzCV+c70fXIrZ9sF6uAqtnZcAyQ1yfp?=
 =?iso-8859-1?Q?A0U+VkZYyBLWTff5bArezNglPgoAIYwMSEvw/MBBxHzY8ejXB6U4PokXFd?=
 =?iso-8859-1?Q?QrA94doxlBZWYBTqACrq5Pxg6LOMLqmG6fBq5EfDfHb58PJdzlOLcqYhcc?=
 =?iso-8859-1?Q?2A5up4cFoXYaaPOj/eQyBMF0sN6EgrnpdaWF01tnyQcV/G6EfQkco1MG0B?=
 =?iso-8859-1?Q?IG+pQqJfjCsjhDRvUOJGTIBpcHJjCGvQzggCS7buAOPZMwtVAdB9eIXJC1?=
 =?iso-8859-1?Q?GjfdPzTBg9MP3zI5Cr13aydDy6UBOqoqI/CPW9XoPCXEgGw1bL1RgBnUHJ?=
 =?iso-8859-1?Q?cR1aFoT5bKRUXNsz15byJ/koRzkPEkJzFaFnSbgMEgb5X97fv+6nAQSnfh?=
 =?iso-8859-1?Q?boy8TuYZBoF87ZRsqUfOtRQ+ppSTwHPV+TuxBIcA64WWLaQ4SJrve9MxD1?=
 =?iso-8859-1?Q?/547aj3HlC69f1lPNUQOdUMKvtl/oYzrifb/YdjgaMsknnZDwIxYGQ/bPi?=
 =?iso-8859-1?Q?h3g2m2cLmYuAyWlljPwfdg2LDEZM5CR+Q/za5L/BBZGJtJoZqkPpuYRPtT?=
 =?iso-8859-1?Q?6bQvV4nMMB8RZPDXFK83AcO5inZQ0aOWiVqKMoUGtn96m9TO3kciI6UlVR?=
 =?iso-8859-1?Q?ISC+BJCGlnrPcS2NA8SpzZc8FekbpjLRuZzs0LlHTyyJkgqK3BB4ySB0ie?=
 =?iso-8859-1?Q?mpAneapTWoA1G8wqUX09IfstP6gPd7mgfcAsSAheuoR6h9c3M/rW1w3DjY?=
 =?iso-8859-1?Q?TzD9PtYJRTPp5DrM1YmFuPG70uZT4j1erv7bOLh43lCBEo2AG+GZuPio1n?=
 =?iso-8859-1?Q?tphzMHPjJ/hO9TfIrCYPUW3pB7Buh629lzZLEeGNLohCfwCwUG21x8XA?=
 =?iso-8859-1?Q?=3D=3D?=
X-MS-Exchange-CrossTenant-Network-Message-Id: 0b168f11-eaab-41e1-fff4-08daeda635f3
X-MS-Exchange-CrossTenant-AuthSource: MN0PR11MB6059.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 03 Jan 2023 16:18:55.4383
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: cPlXC02Zwz8B8ELkzYKbXUQUom5KBJeUsFJ01hvxNVx77estrnUvgYqWwJghF/L0MDmP3QpPsPIsNML6q61j3w==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR11MB5951
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Jan 03, 2023 at 07:09:20PM +0300, Alexey Lukyachuk wrote:
> On Tue, 3 Jan 2023 07:46:40 -0500
> Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
>=20
> > On Mon, Jan 02, 2023 at 04:56:49PM +0300, Alexey Lukyachuk wrote:
> > > On Tue, 27 Dec 2022 20:40:03 +0300
> > > Alexey Lukyachuk <skif@skif-web.ru> wrote:
> > >=20
> > > > On Tue, 27 Dec 2022 11:39:25 -0500
> > > > Rodrigo Vivi <rodrigo.vivi@intel.com> wrote:
> > > >=20
> > > > > On Sun, Dec 25, 2022 at 09:55:08PM +0300, Alexey Lukyanchuk wrote=
:
> > > > > > dell wyse 3040 doesn't peform poweroff properly, but instead re=
mains in=20
> > > > > > turned power on state.
> > > > >=20
> > > > > okay, the motivation is explained in the commit msg..
> > > > >=20
> > > > > > Additional mutex_lock and=20
> > > > > > intel_crtc_wait_for_next_vblank=20
> > > > > > feature 6.2 kernel resolve this trouble.
> > > > >=20
> > > > > but this why is not very clear... seems that by magic it was foun=
d,
> > > > > without explaining what race we are really protecting here.
> > > > >=20
> > > > > but even worse is:
> > > > > what about those many random vblank waits in the code? what's the
> > > > > reasoning?
> > > > >=20
> > > > > >=20
> > > > > > cc: stable@vger.kernel.org
> > > > > > original commit Link: https://patchwork.freedesktop.org/patch/5=
08926/
> > > > > > fixes: fe0f1e3bfdfeb53e18f1206aea4f40b9bd1f291c
> > > > > > Signed-off-by: Alexey Lukyanchuk <skif@skif-web.ru>
> > > > > > ---
> > > > > > I got some troubles with this device (dell wyse 3040) since ker=
nel 5.11
> > > > > > started to use i915_driver_shutdown function. I found solution =
here:
> > > > > >=20
> > > > > > https://lore.kernel.org/dri-devel/Y1wd6ZJ8LdJpCfZL@intel.com/#r
> > > > > >=20
> > > > > > ---
> > > > > >  drivers/gpu/drm/i915/display/intel_audio.c | 37 ++++++++++++++=
+-------
> > > > > >  1 file changed, 25 insertions(+), 12 deletions(-)
> > > > > >=20
> > > > > > diff --git a/drivers/gpu/drm/i915/display/intel_audio.c b/drive=
rs/gpu/drm/i915/display/intel_audio.c
> > > > > > index aacbc6da8..44344ecdf 100644
> > > > > > --- a/drivers/gpu/drm/i915/display/intel_audio.c
> > > > > > +++ b/drivers/gpu/drm/i915/display/intel_audio.c
> > > > > > @@ -336,6 +336,7 @@ static void g4x_audio_codec_disable(struct =
intel_encoder *encoder,
> > > > > >  				    const struct drm_connector_state *old_conn_state)
> > > > > >  {
> > > > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.d=
ev);
> > > > > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uap=
i.crtc);
> > > > > >  	u32 eldv, tmp;
> > > > > > =20
> > > > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > > > > > @@ -348,6 +349,9 @@ static void g4x_audio_codec_disable(struct =
intel_encoder *encoder,
> > > > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_CNTL_ST);
> > > > > >  	tmp &=3D ~eldv;
> > > > > >  	intel_de_write(dev_priv, G4X_AUD_CNTL_ST, tmp);
> > > > > > +
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > >  }
> > > > > > =20
> > > > > >  static void g4x_audio_codec_enable(struct intel_encoder *encod=
er,
> > > > > > @@ -355,12 +359,15 @@ static void g4x_audio_codec_enable(struct=
 intel_encoder *encoder,
> > > > > >  				   const struct drm_connector_state *conn_state)
> > > > > >  {
> > > > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.d=
ev);
> > > > > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.cr=
tc);
> > > > > >  	struct drm_connector *connector =3D conn_state->connector;
> > > > > >  	const u8 *eld =3D connector->eld;
> > > > > >  	u32 eldv;
> > > > > >  	u32 tmp;
> > > > > >  	int len, i;
> > > > > > =20
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > +
> > > > > >  	tmp =3D intel_de_read(dev_priv, G4X_AUD_VID_DID);
> > > > > >  	if (tmp =3D=3D INTEL_AUDIO_DEVBLC || tmp =3D=3D INTEL_AUDIO_D=
EVCL)
> > > > > >  		eldv =3D G4X_ELDV_DEVCL_DEVBLC;
> > > > > > @@ -493,6 +500,7 @@ static void hsw_audio_codec_disable(struct =
intel_encoder *encoder,
> > > > > >  				    const struct drm_connector_state *old_conn_state)
> > > > > >  {
> > > > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.d=
ev);
> > > > > > +	struct intel_crtc *crtc =3D to_intel_crtc(old_crtc_state->uap=
i.crtc);
> > > > > >  	enum transcoder cpu_transcoder =3D old_crtc_state->cpu_transc=
oder;
> > > > > >  	u32 tmp;
> > > > > > =20
> > > > > > @@ -508,6 +516,10 @@ static void hsw_audio_codec_disable(struct=
 intel_encoder *encoder,
> > > > > >  		tmp |=3D AUD_CONFIG_N_VALUE_INDEX;
> > > > > >  	intel_de_write(dev_priv, HSW_AUD_CFG(cpu_transcoder), tmp);
> > > > > > =20
> > > > > > +
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > +
> > > > > >  	/* Invalidate ELD */
> > > > > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_PIN_ELD_CP_VLD);
> > > > > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > > > > > @@ -633,6 +645,7 @@ static void hsw_audio_codec_enable(struct i=
ntel_encoder *encoder,
> > > > > >  				   const struct drm_connector_state *conn_state)
> > > > > >  {
> > > > > >  	struct drm_i915_private *dev_priv =3D to_i915(encoder->base.d=
ev);
> > > > > > +	struct intel_crtc *crtc =3D to_intel_crtc(crtc_state->uapi.cr=
tc);
> > > > > >  	struct drm_connector *connector =3D conn_state->connector;
> > > > > >  	enum transcoder cpu_transcoder =3D crtc_state->cpu_transcoder=
;
> > > > > >  	const u8 *eld =3D connector->eld;
> > > > > > @@ -651,12 +664,7 @@ static void hsw_audio_codec_enable(struct =
intel_encoder *encoder,
> > > > > >  	tmp &=3D ~AUDIO_ELD_VALID(cpu_transcoder);
> > > > > >  	intel_de_write(dev_priv, HSW_AUD_PIN_ELD_CP_VLD, tmp);
> > > > > > =20
> > > > > > -	/*
> > > > > > -	 * FIXME: We're supposed to wait for vblank here, but we have=
 vblanks
> > > > > > -	 * disabled during the mode set. The proper fix would be to p=
ush the
> > > > > > -	 * rest of the setup into a vblank work item, queued here, bu=
t the
> > > > > > -	 * infrastructure is not there yet.
> > > > > > -	 */
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > =20
> > > > > >  	/* Reset ELD write address */
> > > > > >  	tmp =3D intel_de_read(dev_priv, HSW_AUD_DIP_ELD_CTRL(cpu_tran=
scoder));
> > > > > > @@ -705,6 +713,8 @@ static void ilk_audio_codec_disable(struct =
intel_encoder *encoder,
> > > > > >  		aud_cntrl_st2 =3D CPT_AUD_CNTRL_ST2;
> > > > > >  	}
> > > > > > =20
> > > > > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > > > > +
> > > > > >  	/* Disable timestamps */
> > > > > >  	tmp =3D intel_de_read(dev_priv, aud_config);
> > > > > >  	tmp &=3D ~AUD_CONFIG_N_VALUE_INDEX;
> > > > > > @@ -721,6 +731,10 @@ static void ilk_audio_codec_disable(struct=
 intel_encoder *encoder,
> > > > > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > > > > >  	tmp &=3D ~eldv;
> > > > > >  	intel_de_write(dev_priv, aud_cntrl_st2, tmp);
> > > > > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > > > > > +
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > >  }
> > > > > > =20
> > > > > >  static void ilk_audio_codec_enable(struct intel_encoder *encod=
er,
> > > > > > @@ -740,12 +754,7 @@ static void ilk_audio_codec_enable(struct =
intel_encoder *encoder,
> > > > > >  	if (drm_WARN_ON(&dev_priv->drm, port =3D=3D PORT_A))
> > > > > >  		return;
> > > > > > =20
> > > > > > -	/*
> > > > > > -	 * FIXME: We're supposed to wait for vblank here, but we have=
 vblanks
> > > > > > -	 * disabled during the mode set. The proper fix would be to p=
ush the
> > > > > > -	 * rest of the setup into a vblank work item, queued here, bu=
t the
> > > > > > -	 * infrastructure is not there yet.
> > > > > > -	 */
> > > > > > +	intel_crtc_wait_for_next_vblank(crtc);
> > > > > > =20
> > > > > >  	if (HAS_PCH_IBX(dev_priv)) {
> > > > > >  		hdmiw_hdmiedid =3D IBX_HDMIW_HDMIEDID(pipe);
> > > > > > @@ -767,6 +776,8 @@ static void ilk_audio_codec_enable(struct i=
ntel_encoder *encoder,
> > > > > > =20
> > > > > >  	eldv =3D IBX_ELD_VALID(port);
> > > > > > =20
> > > > > > +	mutex_lock(&dev_priv->display.audio.mutex);
> > > > > > +
> > > > > >  	/* Invalidate ELD */
> > > > > >  	tmp =3D intel_de_read(dev_priv, aud_cntrl_st2);
> > > > > >  	tmp &=3D ~eldv;
> > > > > > @@ -798,6 +809,8 @@ static void ilk_audio_codec_enable(struct i=
ntel_encoder *encoder,
> > > > > >  	else
> > > > > >  		tmp |=3D audio_config_hdmi_pixel_clock(crtc_state);
> > > > > >  	intel_de_write(dev_priv, aud_config, tmp);
> > > > > > +
> > > > > > +	mutex_unlock(&dev_priv->display.audio.mutex);
> > > > > >  }
> > > > > > =20
> > > > > >  /**
> > > > > > --=20
> > > > > > 2.25.1
> > > > > >=20
> > > >=20
> > > >=20
> > > > I would like to say, that this solution was found in drm-tip reposi=
tory:
> > > > link: git://anongit.freedesktop.org/drm-tip
> > > > I will quotate original commit message from Ville Syrj=E4l=E4=20
> > > > <ville.syrjala@linux.intel.com>: "The spec tells us to do a bunch o=
f=20
> > > > vblank waits in the audio enable/disable sequences. Make it so."
> > > > So it's just a backport of accepted patch.
> > > > Which i wanna to propagate to stable versions
> > >=20
> > >=20
> > > Yes, I have checked 6.2-rc2 and everything work fine. I want to backp=
ort
> > > this commit to 6.0 and 6.1 because my company going to use these vers=
ions.
> > > Maybe it will be useful for 5.15, companies and vendors are passionat=
e about
> > > LTS kernel ( I am edge to make special version of this patch for 5.15
> > > because hank 3 will be failed with it.).
> > > I am fully supportive with you that trouble is in timings/ locking ch=
anges.
> > > Early in detecting process I made some sleeps and it's help but not r=
eliable.
> > > Regarding to your question about fdo gitlab, I went to do it. And in =
process
> > >  ("Before filing the bug, please try to reproduce your issue with the=
 latest
> > >  kernel. Use the latest drm-tip branch") I found that trouble is reso=
lves.
> > > Using bisect and tests, I got needed commit.
> >=20
> > okay, so the only commit we need is this:
> > https://patchwork.freedesktop.org/patch/508926/
> > ?
> >=20
> > and nothing else?
>=20
> Yes, this patch is enough.
>=20
> >=20
> > If we want this to be included in older released active kernel versions=
 we
> > need to follow this process:
> >=20
> > https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
> >=20
> > We cannot create a new patch like the origin of this thread.
> >=20
>=20
> May I ask you for a little additional explanation?
> I submitted my patch with adding <stable@vger.kernel.org> to CC.
> What else should I do?
> Maybe I should send new thread and send it only to <stable@vger.kernel.or=
g> ?
> Should I make separate version for 5.15 lts?

Your patch is not the right approach. Please read the rules in the given li=
nk.

But also, even if you were backporting the original patch following the wri=
tten
rules, it looks like Jani doesn't agree that it is a right fix, but just ma=
sking
the issue by coincidence apparently, if I understood him well.

Ville, thoughts on this issue and what patches to backport?

>=20
> > >=20
> > > Also I add log (by netconsole) from 5.15 kernel
> > >=20
> > > [   60.031680] ------------[ cut here ]------------
> > > [   60.031709] i915 0000:00:02.0: drm_WARN_ON(!intel_irqs_enabled(dev=
_priv))
> > > [   60.031766] WARNING: CPU: 1 PID: 1964 at drivers/gpu/drm/i915/i915=
_irq.c:527 i915_enable_pipestat+0x1b9/0x230 [i915]
> > > [   60.032016] Modules linked in: snd_soc_sst_cht_bsw_rt5672 snd_hdmi=
_lpe_audio mei_hdcp intel_rapl_msr intel_powerclamp coretemp kvm_intel kvm =
punit_atom_debug crct10dif_pclmul ghash_clmulni_intel joydev input_leds aes=
ni_intel crypto_simd cryptd snd_sof_acpi_intel_byt intel_cstate snd_sof_int=
el_ipc snd_sof_acpi snd_sof_intel_atom dell_wmi snd_sof_xtensa_dsp snd_sof =
dell_smbios ledtrig_audio dcdbas snd_intel_sst_acpi nls_iso8859_1 snd_soc_a=
cpi_intel_match sparse_keymap snd_soc_acpi i915 efi_pstore snd_intel_sst_co=
re wmi_bmof dell_wmi_descriptor snd_soc_sst_atom_hifi2_platform snd_soc_rt5=
670 snd_intel_dspcfg intel_chtdc_ti_pwrbtn snd_soc_rl6231 snd_intel_sdw_acp=
i ttm drm_kms_helper snd_soc_core cec snd_compress ac97_bus rc_core process=
or_thermal_device_pci_legacy snd_pcm_dmaengine i2c_algo_bit processor_therm=
al_device fb_sys_fops processor_thermal_rfim snd_pcm snd_seq_midi syscopyar=
ea processor_thermal_mbox sysfillrect processor_thermal_rapl intel_rapl_com=
mon mei_txe intel_soc_dts_iosf
> > > [   60.032231]  snd_seq_midi_event mei intel_xhci_usb_role_switch sys=
imgblt snd_rawmidi snd_seq snd_seq_device snd_timer snd soundcore 8250_dw i=
nt3406_thermal mac_hid int3403_thermal int340x_thermal_zone int3400_thermal=
 acpi_pad intel_int0002_vgpio acpi_thermal_rel sch_fq_codel ipmi_devintf ip=
mi_msghandler msr parport_pc ppdev lp parport drm ip_tables x_tables autofs=
4 overlay hid_logitech_hidpp hid_logitech_dj hid_generic usbhid hid netcons=
ole mmc_block crc32_pclmul r8169 realtek lpc_ich sdhci_pci xhci_pci cqhci x=
hci_pci_renesas dw_dmac wmi sdhci_acpi video dw_dmac_core intel_soc_pmic_ch=
tdc_ti sdhci
> > > [   60.032427] CPU: 1 PID: 1964 Comm: plymouthd Not tainted 5.15.0-57=
-generic #63~20.04.1-Ubuntu
> > > [   60.032440] Hardware name: Dell Inc. Wyse 3040 Thin Client/0G56C0,=
 BIOS 1.2.4 01/18/2018
> > > [   60.032450] RIP: 0010:i915_enable_pipestat+0x1b9/0x230 [i915]
> > > [   60.032669] Code: 89 55 cc 44 89 5d d0 44 89 4d d4 e8 c1 15 ae d8 =
48 8b 55 c0 48 c7 c1 a8 72 b5 c0 48 c7 c7 54 b5 b8 c0 48 89 c6 e8 0e 21 f5 =
d8 <0f> 0b 44 8b 55 cc 44 8b 5d d0 44 8b 4d d4 e9 9d fe ff ff 4c 89 f6
> > > [   60.032682] RSP: 0018:ffffaaa50070b878 EFLAGS: 00010086
> > > [   60.032694] RAX: 0000000000000000 RBX: ffff980ec8080000 RCX: fffff=
fff9ab7a748
> > > [   60.032703] RDX: 00000000ffffdfff RSI: ffffaaa50070b6b8 RDI: 00000=
00000000001
> > > [   60.032713] RBP: ffffaaa50070b8c0 R08: 0000000000000003 R09: 00000=
00000000001
> > > [   60.032721] R10: ffffffff9b21f3b6 R11: 000000009b21f38a R12: 00000=
00000000004
> > > [   60.032730] R13: 0000000000000000 R14: 0000000000000000 R15: ffff9=
80ec8080000
> > > [   60.032740] FS:  00007f0967eec740(0000) GS:ffff980f34280000(0000) =
knlGS:0000000000000000
> > > [   60.032752] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> > > [   60.032762] CR2: 00007f7f5f21eaa4 CR3: 000000000a34a000 CR4: 00000=
000001006e0
> > > [   60.032772] Call Trace:
> > > [   60.032781]  <TASK>
> > > [   60.032793]  ? drm_crtc_vblank_helper_get_vblank_timestamp_interna=
l+0xe0/0x370 [drm]
> > > [   60.032899]  i965_enable_vblank+0x3d/0x60 [i915]
> > > [   60.033139]  drm_vblank_enable+0xfd/0x1a0 [drm]
> > > [   60.033240]  drm_vblank_get+0xaf/0x100 [drm]
> > > [   60.033335]  drm_crtc_vblank_get+0x17/0x20 [drm]
> > > [   60.033426]  intel_pipe_update_start+0x128/0x2f0 [i915]
> > > [   60.033689]  ? wait_woken+0x60/0x60
> > > [   60.033710]  intel_update_crtc+0xd2/0x420 [i915]
> > > [   60.033969]  intel_commit_modeset_enables+0x74/0xa0 [i915]
> > > [   60.034228]  intel_atomic_commit_tail+0x587/0x14e0 [i915]
> > > [   60.034488]  intel_atomic_commit+0x3a6/0x410 [i915]
> > > [   60.034746]  drm_atomic_commit+0x4a/0x60 [drm]
> > > [   60.034849]  drm_atomic_helper_set_config+0x80/0xc0 [drm_kms_helpe=
r]
> > > [   60.034921]  drm_mode_setcrtc+0x1ff/0x7d0 [drm]
> > > [   60.035011]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
> > > [   60.035098]  drm_ioctl_kernel+0xb2/0x100 [drm]
> > > [   60.035182]  drm_ioctl+0x275/0x4a0 [drm]
> > > [   60.035265]  ? drm_mode_getcrtc+0x1e0/0x1e0 [drm]
> > > [   60.035354]  __x64_sys_ioctl+0x95/0xd0
> > > [   60.035372]  do_syscall_64+0x5c/0xc0
> > > [   60.035388]  ? exit_to_user_mode_prepare+0x3d/0x1c0
> > > [   60.035404]  ? syscall_exit_to_user_mode+0x27/0x50
> > > [   60.035418]  ? do_syscall_64+0x69/0xc0
> > > [   60.035431]  ? syscall_exit_to_user_mode+0x27/0x50
> > > [   60.035445]  ? do_syscall_64+0x69/0xc0
> > > [   60.035459]  ? syscall_exit_to_user_mode+0x27/0x50
> > > [   60.035474]  ? do_syscall_64+0x69/0xc0
> > > [   60.035487]  ? do_syscall_64+0x69/0xc0
> > > [   60.035501]  ? do_syscall_64+0x69/0xc0
> > > [   60.035514]  entry_SYSCALL_64_after_hwframe+0x61/0xcb
> > > [   60.035528] RIP: 0033:0x7f09681aa3ab
> > > [   60.035542] Code: 0f 1e fa 48 8b 05 e5 7a 0d 00 64 c7 00 26 00 00 =
00 48 c7 c0 ff ff ff ff c3 66 0f 1f 44 00 00 f3 0f 1e fa b8 10 00 00 00 0f =
05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d b5 7a 0d 00 f7 d8 64 89 01 48
> > > [   60.035554] RSP: 002b:00007fff40931638 EFLAGS: 00000246 ORIG_RAX: =
0000000000000010
> > > [   60.035567] RAX: ffffffffffffffda RBX: 00007fff40931670 RCX: 00007=
f09681aa3ab
> > > [   60.035576] RDX: 00007fff40931670 RSI: 00000000c06864a2 RDI: 00000=
00000000009
> > > [   60.035584] RBP: 00000000c06864a2 R08: 0000000000000000 R09: 00005=
560dd410090
> > > [   60.035592] R10: 0000000000000000 R11: 0000000000000246 R12: 00000=
0000000007f
> > > [   60.035601] R13: 0000000000000009 R14: 00005560dd40ffe0 R15: 00005=
560dd410020
> > > [   60.035613]  </TASK>
> > > [   60.035622] ---[ end trace a700e85625cc752d ]---
>=20
