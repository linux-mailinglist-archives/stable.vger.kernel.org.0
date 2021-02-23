Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EB70C322B58
	for <lists+stable@lfdr.de>; Tue, 23 Feb 2021 14:22:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232763AbhBWNWz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 23 Feb 2021 08:22:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:18792 "EHLO mga01.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229791AbhBWNWy (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 23 Feb 2021 08:22:54 -0500
IronPort-SDR: /0sqHgveO0pFaQK8FRiK8XW88z2rz8scqQRQaBU5w7gO0/kQAdsiB2KpVW3PX4cUt8KQTU3Y6J
 Nir8eVZYzTRw==
X-IronPort-AV: E=McAfee;i="6000,8403,9903"; a="204227255"
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="204227255"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga101.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Feb 2021 05:21:08 -0800
IronPort-SDR: SqzV2J8UYCZcd7OQicr2SiY9ITDXP+eivb3GyAu3oMlj79ZziHGg77wtk3YRXowUwiLLrDy659
 Ut4qHLHmalDg==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,200,1610438400"; 
   d="scan'208";a="366581461"
Received: from stinkbox.fi.intel.com (HELO stinkbox) ([10.237.72.171])
  by orsmga006.jf.intel.com with SMTP; 23 Feb 2021 05:21:05 -0800
Received: by stinkbox (sSMTP sendmail emulation); Tue, 23 Feb 2021 15:21:04 +0200
Date:   Tue, 23 Feb 2021 15:21:04 +0200
From:   Ville =?iso-8859-1?Q?Syrj=E4l=E4?= <ville.syrjala@linux.intel.com>
To:     "Lin, Wayne" <Wayne.Lin@amd.com>
Cc:     "dri-devel@lists.freedesktop.org" <dri-devel@lists.freedesktop.org>,
        "Brol, Eryk" <Eryk.Brol@amd.com>,
        "Zhuo, Qingqing" <Qingqing.Zhuo@amd.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Zuo, Jerry" <Jerry.Zuo@amd.com>,
        "Kazlauskas, Nicholas" <Nicholas.Kazlauskas@amd.com>,
        Dhinakaran Pandiyan <dhinakaran.pandiyan@intel.com>
Subject: Re: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
Message-ID: <YDUBQE3acwhDbUxp@intel.com>
References: <20210222040027.23505-1-Wayne.Lin@amd.com>
 <20210222040027.23505-3-Wayne.Lin@amd.com>
 <YDPjFzPdfZXJqex8@intel.com>
 <BN8PR12MB47700A55800116A14DF96B1FFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <BN8PR12MB47700A55800116A14DF96B1FFC809@BN8PR12MB4770.namprd12.prod.outlook.com>
X-Patchwork-Hint: comment
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Feb 23, 2021 at 05:32:36AM +0000, Lin, Wayne wrote:
> [AMD Public Use]
> 
> > -----Original Message-----
> > From: Ville Syrjälä <ville.syrjala@linux.intel.com>
> > Sent: Tuesday, February 23, 2021 1:00 AM
> > To: Lin, Wayne <Wayne.Lin@amd.com>
> > Cc: dri-devel@lists.freedesktop.org; Brol, Eryk <Eryk.Brol@amd.com>; Zhuo, Qingqing <Qingqing.Zhuo@amd.com>;
> > stable@vger.kernel.org; Zuo, Jerry <Jerry.Zuo@amd.com>; Kazlauskas, Nicholas <Nicholas.Kazlauskas@amd.com>; Dhinakaran
> > Pandiyan <dhinakaran.pandiyan@intel.com>
> > Subject: Re: [PATCH 2/2] drm/dp_mst: Set CLEAR_PAYLOAD_ID_TABLE as broadcast
> >
> > On Mon, Feb 22, 2021 at 12:00:27PM +0800, Wayne Lin wrote:
> > > [Why & How]
> > > According to DP spec, CLEAR_PAYLOAD_ID_TABLE is a path broadcast
> > > request message and current implementation is incorrect. Fix it.
> > >
> > > Signed-off-by: Wayne Lin <Wayne.Lin@amd.com>
> > > Cc: stable@vger.kernel.org
> > > ---
> > >  drivers/gpu/drm/drm_dp_mst_topology.c | 4 +++-
> > >  1 file changed, 3 insertions(+), 1 deletion(-)
> > >
> > > diff --git a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > index 713ef3b42054..6d73559046e5 100644
> > > --- a/drivers/gpu/drm/drm_dp_mst_topology.c
> > > +++ b/drivers/gpu/drm/drm_dp_mst_topology.c
> > > @@ -1072,6 +1072,7 @@ static void build_clear_payload_id_table(struct
> > > drm_dp_sideband_msg_tx *msg)
> > >
> > >  req.req_type = DP_CLEAR_PAYLOAD_ID_TABLE;
> > >  drm_dp_encode_sideband_req(&req, msg);
> > > +msg->path_msg = true;
> > >  }
> > >
> > >  static int build_enum_path_resources(struct drm_dp_sideband_msg_tx
> > > *msg, @@ -2722,7 +2723,8 @@ static int set_hdr_from_dst_qlock(struct
> > > drm_dp_sideband_msg_hdr *hdr,
> > >
> > >  req_type = txmsg->msg[0] & 0x7f;
> > >  if (req_type == DP_CONNECTION_STATUS_NOTIFY ||
> > > -req_type == DP_RESOURCE_STATUS_NOTIFY)
> > > +req_type == DP_RESOURCE_STATUS_NOTIFY ||
> > > +req_type == DP_CLEAR_PAYLOAD_ID_TABLE)
> > >  hdr->broadcast = 1;
> >
> > Looks correct.
> > Reviewed-by: Ville Syrjälä <ville.syrjala@linux.intel.com>
> >
> > Hmm. Looks like we're missing DP_POWER_DOWN_PHY and DP_POWER_UP_PHY here as well. We do try to send them as path
> > requests, but apparently forget to mark them as broadcast messages.
> Hi Ville,
> I also look up the spec but DP_POWER_DOWN_PHY & DP_POWER_UP_PHY seems to be defined as path or node request only. Not broadcast message. Please correct me if I'm wrong here.

Doh. Yeah, you're correct. Not sure what section I was reading earlier
when I came to that conclusion.

> Appreciate for your time!
> >
> > >  else
> > >  hdr->broadcast = 0;
> > > --
> > > 2.17.1
> > >
> > > _______________________________________________
> > > dri-devel mailing list
> > > dri-devel@lists.freedesktop.org
> > > https://nam11.safelinks.protection.outlook.com/?url=https%3A%2F%2Flist
> > > s.freedesktop.org%2Fmailman%2Flistinfo%2Fdri-devel&amp;data=04%7C01%7C
> > > Wayne.Lin%40amd.com%7C372bbed7b5354ca05f5608d8d753533a%7C3dd8961fe4884
> > > e608e11a82d994e183d%7C0%7C0%7C637496100180287539%7CUnknown%7CTWFpbGZsb
> > > 3d8eyJWIjoiMC4wLjAwMDAiLCJQIjoiV2luMzIiLCJBTiI6Ik1haWwiLCJXVCI6Mn0%3D%
> > > 7C1000&amp;sdata=2uhm9Nf31hfhf%2FbmwfqYW7b6ay9swWb8oS10Uc%2FVFRQ%3D&am
> > > p;reserved=0
> >
> > --
> > Ville Syrjälä
> > Intel
> Regards,
> Wayne Lin

-- 
Ville Syrjälä
Intel
