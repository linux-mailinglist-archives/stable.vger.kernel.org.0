Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 55F4D7EE84
	for <lists+stable@lfdr.de>; Fri,  2 Aug 2019 10:13:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403942AbfHBINk (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 2 Aug 2019 04:13:40 -0400
Received: from wout3-smtp.messagingengine.com ([64.147.123.19]:54907 "EHLO
        wout3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2403892AbfHBINj (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 2 Aug 2019 04:13:39 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id 7EF4A396;
        Fri,  2 Aug 2019 04:13:38 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Fri, 02 Aug 2019 04:13:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=hmlf4bC9Vk0FOVsRROWxGhLGg/u
        unUQ/nq5d4O95tew=; b=Ny4OHMQMoqcMrY+tWTzIApNCg+FX+KSqJHYj7abssop
        toh+VaCKe6MTSJLBM1hcilU6kjZD+5SqXJMahC9SnEwrQpTgyP3dH61g1/7wzpLl
        4pQWIdvqPdasYEjTPT1qo4RL1Jm29I9XQOAkiW8uTz23yyStsbyMYYc/cQ3ZiwL4
        A3P6mpanGdTrDMvoJRX49eBccssfSYYpz5qvJ4KxKs3opFuL46qFjnf4DXiips0z
        V6O6TK4uHIqtyVlb9bv+SWhZgBGUg+YIcWd6S2WHY7o40WaErx8JE6kcooE1DZqL
        9OLainm9hzArFW7WsFumfrjD3ovexPrZLcdKupch8Iw==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=hmlf4b
        C9Vk0FOVsRROWxGhLGg/uunUQ/nq5d4O95tew=; b=K1DePlk6Gqrk4YpHg+l5Qt
        ZDBeimBKVcY91nhgIa3NC/J1XzDXrI6Kv16gnRGZFJdZ1zICkPyShFcEg7F9JCTQ
        HkV2x8gyGO2WuqjApL1FR7wr4TB+1ILhG6Xtlw7Lg6hH3hbOCxohwSSSDBujw+4x
        k4xj475g8gDfzhlFrvn8mcI/K/aMCpycv2XPqSIOJb2MzXc4bF8gmB7egWka1cc2
        CFRN9jtL/Z8HzumVhjo16vaPz591A+R7hdTyTGwemgUBbYnQPDe9kI3U32B+N5mk
        H8lWgI37iEdKVQysIqTrGNYTxAi0Cxd50cjjpBACQIuxTJPNJXQyPdbhfKcgqp6g
        ==
X-ME-Sender: <xms:sfBDXYi1lQAfIJB3D7Dy1OkGi2UGbez2V5TKswApwmXXs_Oox8Guag>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrleekgdduvdelucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:sfBDXcgNSa1To1MGB_40mcRldwRciEckmE7CBnnIIVCBIE-jIWoJKQ>
    <xmx:sfBDXWi4fRRj1eQcOYCPkX-jFhZzRLJv5e53P_7WmL5i-OhlrKh_3Q>
    <xmx:sfBDXUKxKhLsAsLV9gdeFP29kCuUCJJgTsKkR7QOPqMYZX3I5RQUaA>
    <xmx:svBDXSQ7Kqp33DubGvo4EQ-1rTJhVe1RmWPc6q0PflOtQBUpksQrOg>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id 61E788005C;
        Fri,  2 Aug 2019 04:13:37 -0400 (EDT)
Date:   Fri, 2 Aug 2019 10:13:35 +0200
From:   Greg KH <greg@kroah.com>
To:     "Yan, Zheng" <zyan@redhat.com>
Cc:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        idryomov@redhat.com, jlayton@redhat.com, stable@vger.kernel.org
Subject: Re: [PATCH 8/8] ceph: hold i_ceph_lock when removing caps for
 freeing inode
Message-ID: <20190802081335.GJ26174@kroah.com>
References: <20190523080646.19632-8-zyan@redhat.com>
 <20190529131452.43F372081C@mail.kernel.org>
 <1fb32a0f-545c-2ace-3dcd-8df6ca9d32e6@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1fb32a0f-545c-2ace-3dcd-8df6ca9d32e6@redhat.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, May 30, 2019 at 09:46:35AM +0800, Yan, Zheng wrote:
> On 5/29/19 9:14 PM, Sasha Levin wrote:
> > Hi,
> > 
> > [This is an automated email]
> > 
> > This commit has been processed because it contains a -stable tag.
> > The stable tag indicates that it's relevant for the following trees: all
> > 
> > The bot has tested the following trees: v5.1.4, v5.0.18, v4.19.45, v4.14.121, v4.9.178, v4.4.180, v3.18.140.
> > 
> > v5.1.4: Build OK!
> > v5.0.18: Failed to apply! Possible dependencies:
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> > 
> > v4.19.45: Failed to apply! Possible dependencies:
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> > 
> > v4.14.121: Failed to apply! Possible dependencies:
> >      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
> >      a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> > 
> > v4.9.178: Failed to apply! Possible dependencies:
> >      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
> >      a57d9064e4ee4 ("ceph: flush pending works before shutdown super")
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> > 
> > v4.4.180: Failed to apply! Possible dependencies:
> >      13d1ad16d05ee ("libceph: move message allocation out of ceph_osdc_alloc_request()")
> >      34b759b4a22b0 ("ceph: kill ceph_empty_snapc")
> >      3f1af42ad0fad ("libceph: enable large, variable-sized OSD requests")
> >      5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
> >      7627151ea30bc ("libceph: define new ceph_file_layout structure")
> >      779fe0fb8e188 ("ceph: rados pool namespace support")
> >      922dab6134178 ("libceph, rbd: ceph_osd_linger_request, watch/notify v2")
> >      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
> >      ae458f5a171ba ("libceph: make r_request msg_size calculation clearer")
> >      c41d13a31fefe ("rbd: use header_oid instead of header_name")
> >      c8fe9b17d055f ("ceph: Asynchronous IO support")
> >      d30291b985d18 ("libceph: variable-sized ceph_object_id")
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> > 
> > v3.18.140: Failed to apply! Possible dependencies:
> >      10183a69551f7 ("ceph: check OSD caps before read/write")
> >      28127bdd2f843 ("ceph: convert inline data to normal data before data write")
> >      31c542a199d79 ("ceph: add inline data to pagecache")
> >      5be0389dac662 ("ceph: re-send AIO write request when getting -EOLDSNAP error")
> >      70db4f3629b34 ("ceph: introduce a new inode flag indicating if cached dentries are ordered")
> >      745a8e3bccbc6 ("ceph: don't pre-allocate space for cap release messages")
> >      7627151ea30bc ("libceph: define new ceph_file_layout structure")
> >      779fe0fb8e188 ("ceph: rados pool namespace support")
> >      83701246aee8f ("ceph: sync read inline data")
> >      a1c6b8358171c ("ceph: define argument structure for handle_cap_grant")
> >      affbc19a68f99 ("ceph: make sure syncfs flushes all cap snaps")
> >      c8fe9b17d055f ("ceph: Asynchronous IO support")
> >      d30291b985d18 ("libceph: variable-sized ceph_object_id")
> >      d3383a8e37f80 ("ceph: avoid block operation when !TASK_RUNNING (ceph_mdsc_sync)")
> >      e3ec8d6898f71 ("ceph: send cap releases more aggressively")
> >      e96a650a8174e ("ceph, rbd: delete unnecessary checks before two function calls")
> > 
> > 
> > How should we proceed with this patch?
> > 
> 
> please use following patch for old kernels
> 
> Regards
> Yan, Zheng
> 
> ---
> From 55937416f12e096621b06ada7554cacb89d06e97 Mon Sep 17 00:00:00 2001
> From: "Yan, Zheng" <zyan@redhat.com>
> Date: Thu, 23 May 2019 11:01:37 +0800
> Subject: [PATCH] ceph: hold i_ceph_lock when removing caps for freeing inode
> 
> ceph_d_revalidate(, LOOKUP_RCU) may call __ceph_caps_issued_mask()
> on a freeing inode.
> 
> Cc: stable@vger.kernel.org
> Signed-off-by: "Yan, Zheng" <zyan@redhat.com>
> Reviewed-by: Jeff Layton <jlayton@redhat.com>
> ---
>  fs/ceph/caps.c | 7 +++++--
>  1 file changed, 5 insertions(+), 2 deletions(-)
> 
> diff --git a/fs/ceph/caps.c b/fs/ceph/caps.c
> index ff5d32cf9578..0fb4e919cdce 100644
> --- a/fs/ceph/caps.c
> +++ b/fs/ceph/caps.c
> @@ -1119,20 +1119,23 @@ static int send_cap_msg(struct cap_msg_args *arg)
>  }
> 
>  /*
> - * Queue cap releases when an inode is dropped from our cache.  Since
> - * inode is about to be destroyed, there is no need for i_ceph_lock.
> + * Queue cap releases when an inode is dropped from our cache.
>   */
>  void ceph_queue_caps_release(struct inode *inode)
>  {
>  	struct ceph_inode_info *ci = ceph_inode(inode);
>  	struct rb_node *p;
> 
> +	/* lock i_ceph_lock, because ceph_d_revalidate(..., LOOKUP_RCU)
> +	 * may call __ceph_caps_issued_mask() on a freeing inode. */
> +	spin_lock(&ci->i_ceph_lock);
>  	p = rb_first(&ci->i_caps);
>  	while (p) {
>  		struct ceph_cap *cap = rb_entry(p, struct ceph_cap, ci_node);
>  		p = rb_next(p);
>  		__ceph_remove_cap(cap, true);
>  	}
> +	spin_unlock(&ci->i_ceph_lock);
>  }
> 
>  /*
> -- 
> 2.17.2

Thanks for the backport, now queued up.

greg k-h
