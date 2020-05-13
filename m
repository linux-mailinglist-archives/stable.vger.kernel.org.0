Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 49AA81D0C5C
	for <lists+stable@lfdr.de>; Wed, 13 May 2020 11:36:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727918AbgEMJgc (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 13 May 2020 05:36:32 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:34697 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727120AbgEMJgc (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 13 May 2020 05:36:32 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id 53E9A5C0096;
        Wed, 13 May 2020 05:36:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute1.internal (MEProxy); Wed, 13 May 2020 05:36:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm3; bh=aktcx0F31Hq4KJ/iBkCoSOsg+5T
        TlFbA8xn53jTs41A=; b=fkKDTA1SEUD5FPqXIopTrADlYnm0UyaL9O7xIdIl03C
        NWgwEWZnVA6vTCtSjAOY1+FW9RGpXlxWk5Viq6zyW1q9BBnmPMBL9fV/DAoBRzjx
        anPXnos6XRMje7Puh4RWGy4diM1buWMMBSkLWrdaJ2Y0Qu6eigmUc3MhBivqXy/r
        zuMPvLMjTlifyqiRLfTpCx5hDXzVHT4dDCQzvt+Tp5P82FD6hHt3YrqeX2glvITH
        djroqAW9igUm9oVun2UB6Ch3B/piePRDJbBhq6jyNNzQ6+Lpq97WKc71tQsrfE3h
        DYbDTf6++wlyfxdNkgYyKPY+tnRzdPa4Psrfy1s02nA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=aktcx0
        F31Hq4KJ/iBkCoSOsg+5TTlFbA8xn53jTs41A=; b=DSJv0jBDpy2iEPiUCT9N14
        bshw3O+IfnOGLcEf8yqiziBTrpOfspsCMhU30JN8J+QvFuN81M3B+Q/o/sf3fKfb
        fxIeKVa1blK700W3Y2B42dTrbWN/dF3KrEbMaYdaEm7ALP84X74Zm4acQhFC03et
        cC70k5KdSToiyekQM4S8bnUaGxf8WlumxBq4h/wYSxcD4mITo+7TOZj7XxYuTpRe
        z/JZUZg+0y6RkWJT+loj9cZ+zn4qp07JgFkuc0ynHrX87yJ7tgMLifKljHnUWmz2
        nX+KgSxstC+fBTmnX8Jvb+qlpEcgcivoHYJFJGtUFLKagDvUSBQ/fsVjBYqvSxEw
        ==
X-ME-Sender: <xms:n7-7XgjCH7jfifFlg5SmVYy3v-8SfaTis85T4ZsZVKAg2fbjXHOaug>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduhedrleeggddukecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepgfduvdfhvd
    eugeeiuedvudeltdegvdetheethfekveekhefgtdelvdfhfedvieegnecuffhomhgrihhn
    pehfrhgvvgguvghskhhtohhprdhorhhgnecukfhppeekfedrkeeirdekledruddtjeenuc
    evlhhushhtvghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvghes
    khhrohgrhhdrtghomh
X-ME-Proxy: <xmx:n7-7XpDpLgU3kx2TN0H1tEh8n8ahlmc-_UpEPVfHH1lyG8l9D2E_Vg>
    <xmx:n7-7XoEq8YI6-eLrqlhgnyYzDHIYWHr54sTEfnR12RGuyXPpfbVsCg>
    <xmx:n7-7XhRrrr5hRNpREgfZn60rz5mD5S-b4iVBXRaQzq2orMj7FGQl8A>
    <xmx:n7-7XupEOOragGfNSCzfqImdN1lnAkivcpIg_JLhyQ8YGHqzWqN33g>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DB46C30662FC;
        Wed, 13 May 2020 05:36:30 -0400 (EDT)
Date:   Wed, 13 May 2020 11:36:25 +0200
From:   Greg KH <greg@kroah.com>
To:     Lee Jones <lee.jones@linaro.org>
Cc:     stable@vger.kernel.org, Joe Moriarty <joe.moriarty@oracle.com>,
        Steven Sistare <steven.sistare@oracle.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: Re: [PATCH 4.4 05/16] drm: NULL pointer dereference
 [null-pointer-deref] (CWE 476) problem
Message-ID: <20200513093625.GD830571@kroah.com>
References: <20200423204014.784944-1-lee.jones@linaro.org>
 <20200423204014.784944-6-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200423204014.784944-6-lee.jones@linaro.org>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Apr 23, 2020 at 09:40:03PM +0100, Lee Jones wrote:
> From: Joe Moriarty <joe.moriarty@oracle.com>
> 
> [ Upstream commit 22a07038c0eaf4d1315a493ce66dcd255accba19 ]
> 
> The Parfait (version 2.1.0) static code analysis tool found the
> following NULL pointer derefernce problem.
> 
> - drivers/gpu/drm/drm_dp_mst_topology.c
> The call to drm_dp_calculate_rad() in function drm_dp_port_setup_pdt()
> could result in a NULL pointer being returned to port->mstb due to a
> failure to allocate memory for port->mstb.
> 
> Signed-off-by: Joe Moriarty <joe.moriarty@oracle.com>
> Reviewed-by: Steven Sistare <steven.sistare@oracle.com>
> Signed-off-by: Daniel Vetter <daniel.vetter@ffwll.ch>
> Link: https://patchwork.freedesktop.org/patch/msgid/20180212195144.98323-3-joe.moriarty@oracle.com
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>  drivers/gpu/drm/drm_dp_mst_topology.c | 8 +++++---
>  1 file changed, 5 insertions(+), 3 deletions(-)

Already in the 4.4.220 release.
