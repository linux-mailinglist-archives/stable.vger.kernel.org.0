Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1577B4BCF34
	for <lists+stable@lfdr.de>; Sun, 20 Feb 2022 15:58:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243997AbiBTOvg (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 20 Feb 2022 09:51:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:58968 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238761AbiBTOvf (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 20 Feb 2022 09:51:35 -0500
Received: from out3-smtp.messagingengine.com (out3-smtp.messagingengine.com [66.111.4.27])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5765245AD8
        for <stable@vger.kernel.org>; Sun, 20 Feb 2022 06:51:14 -0800 (PST)
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailout.nyi.internal (Postfix) with ESMTP id E86065C0217;
        Sun, 20 Feb 2022 09:51:11 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Sun, 20 Feb 2022 09:51:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm3; bh=bBxaZJZsbLlIZtiGi04Ze1DarzKjcjNhKFT69q
        QvhPo=; b=G+2P6ZfX8hW8cuPSncGazABSS+U9N0y2Cj4/FUYa7wyWd4jbBmhlRJ
        w0WGhN3VFJYuK2/k8BHLAS9er8KRb10m9Ezvi3UtnVDGMtFoOQmUHUYUmxfFe51/
        qxiR6vdqoEUWWOU0sMofl14qOC3IHQcT0s4j9OklebBAKhVnpILRs/tkcCuXeslb
        Fjkla3DiooQsRFomqx5mao7nUrZN9dbNOViEUp3EnIyI7xiLKG11ffIPuuwm8Sr/
        sLgbVwDfvZXsn0bS1YCEwhAEXPyrIDx2mGhIoOFtqvllWUCS7iFaS1IjNfaozm0l
        iiEohWIbe4VbJpBC/zoeAivnZ/+Tm5sg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=bBxaZJZsbLlIZtiGi
        04Ze1DarzKjcjNhKFT69qQvhPo=; b=cfjah0NEsgFkYX1tbTP6fJd95ZtjFl7X3
        NFAELFTE2cBhOqzbbCOaVoq85pdsoHUhV7NVYQwzCInyJxVP0EXYrQrGVfJN8SDa
        utBq1SKkcGxulSSdRsqjYcIGrK8UowAv/Ke401FpgDUI0lioBWZh66TAlKj2fQwu
        MnZf5oz88kwIXyYzubLyinZGSNbpbtIiMoWuD87EZ4dlTE1dnh4V/CnolwilwAZd
        hdCRbHARdipzT/MYxMmpiuke+Px2+oqWqlyXrfCXv1k0av8DqYBJ9ZCzJGp9US8w
        J3bV6O+WcwJW3LfaxAEg4q8b7XW+ZQdYtpt2d7iCwDVV3RM8i2zGA==
X-ME-Sender: <xms:X1USYi1Rgls1OUpWqjDOh3JpbXix4oBKWu7JEO3A4TqvrKF2Xv3sYw>
    <xme:X1USYlEa3S7cB7n32UGjAh5-0R6_4RKYzf6dTXTFr2PQpaaf9PP4vlxQ9BH4uGztu
    2gaxGiJQQYJAA>
X-ME-Received: <xmr:X1USYq5S1RGbWkWBLI_eA-igSc5g8fK2Z-9cntIaL-tItXA3KGnBc5BYm9e34CQa_wPmlN4xAJVhXUBle4-A6m1fmfgvmPtt>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddrkeeggdejudcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghgucfm
    jfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuheejgf
    ffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecuvehluhhsthgv
    rhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrd
    gtohhm
X-ME-Proxy: <xmx:X1USYj30Z6FXL1LpRs_rFCE0SNMYQy29VgaiV8V6z2vMXPnnlccT0Q>
    <xmx:X1USYlGQMWmtjgr81lOX-8xqPVePvRRN4up__r2dbr4sD_3L6A-fJw>
    <xmx:X1USYs_UVRvORohgWT0vHFf2ReOTc7Z9F7dFpNSHufkTuSAl2qQikg>
    <xmx:X1USYq5bipT_3LeICAa9O3oSL4bkv0ASS1SWLZ-_YQUXjXBSzi9YLQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Sun,
 20 Feb 2022 09:51:10 -0500 (EST)
Date:   Sun, 20 Feb 2022 15:51:08 +0100
From:   Greg KH <greg@kroah.com>
To:     Theodore Ts'o <tytso@mit.edu>
Cc:     Leah Rumancik <leah.rumancik@gmail.com>, stable@vger.kernel.org,
        Zhang Yi <yi.zhang@huawei.com>
Subject: Re: [PATCH for 5.4 1/3] ext4: check for out-of-order index extents
 in ext4_valid_extent_entries()
Message-ID: <YhJVXB1BeA1Dw045@kroah.com>
References: <20220217225914.40363-1-leah.rumancik@gmail.com>
 <Yg9lLNWNa8FLLhdC@kroah.com>
 <Yg/6IgszAcONwk0n@mit.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yg/6IgszAcONwk0n@mit.edu>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Feb 18, 2022 at 02:57:22PM -0500, Theodore Ts'o wrote:
> Leah, thanks for doing the backport to 5.4!   And Greg, thanks for queuing them up.
> 
> I note that if we first cherry pick into 4.19.y a fix from 5.2 that
> probably should have been cc'ed to stable to begin with:
> 
> 0a944e8a6c66 ("ext4: don't perform block validity checks on the journal inode")

This commit is already in the following releases:
	3.16.85 4.4.221 4.4.263 4.9.221 4.9.263 4.14.178 4.14.227 4.19.73 4.19.182 5.2 5.7.18 5.8.4

> Leah's three backports to 5.4 will then apply to 4.19 LTS; I've run
> regression tests with the cherry-pick of 0a944e8a6c66 and Leah's three
> backports applied to 4.19.230, and the resulting kernel looks fine and
> prevents a kernel crash when running ext4/054.
> 
> Greg, would you prefer that I send the patches for 4.19.y, or do you
> have what you need to do the cherry pick (all of the cherry picks are
> clean, and didn't require any manual resolution)?

The second commit does not apply cleanly, so I would need working
backported ones to get this right.  I have queued up the first one now
already.

thanks,

greg k-h
