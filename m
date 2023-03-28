Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 001136CC0F8
	for <lists+stable@lfdr.de>; Tue, 28 Mar 2023 15:32:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbjC1Ncn (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 28 Mar 2023 09:32:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233291AbjC1Nc2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 28 Mar 2023 09:32:28 -0400
Received: from out1-smtp.messagingengine.com (out1-smtp.messagingengine.com [66.111.4.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1AABC66A
        for <stable@vger.kernel.org>; Tue, 28 Mar 2023 06:32:09 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id F28385C00E7;
        Tue, 28 Mar 2023 09:31:10 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Tue, 28 Mar 2023 09:31:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:content-type:date:date:from:from:in-reply-to
        :in-reply-to:message-id:mime-version:references:reply-to:sender
        :subject:subject:to:to; s=fm2; t=1680010270; x=1680096670; bh=D7
        KaZJ+1YJ+PWeo3Sn8OrXD3p3K/wbxYvtfPD9mZJ0M=; b=X/Oxdc2ycUhdMBFJN6
        VBSWiSTa8nofnRYP0k9O4fA5ashiUqPLzBMY3fLSGiuBylq0Knmz27d/A9UGgAv6
        ZtpZwLxWLlSokqjfOjp2PJD5apjQbsEok2XSc3qJvWA7qIzeCUPHZmnJLpKIoPU1
        xx6zzyZZkwLnmDmjLcvftvpZtvtJY5DMdwkW3D8AkQrM4vTk+vv6KRZ8gr+SevEY
        NNi0EUKhZzOJepMtjN+BZOvMxgyTwfDAeZb1dxoO369NuPwKbhkCvI0R2hnAjhIa
        V3FLviooWJQF/lWQHOkAhY7BaI35zzuDj8A1lWWgU35NGe8k1XwQSIIV+KmnPcyX
        q7FQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:content-type:date:date
        :feedback-id:feedback-id:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm2; t=1680010270; x=1680096670; bh=D7KaZJ+1YJ+PW
        eo3Sn8OrXD3p3K/wbxYvtfPD9mZJ0M=; b=FBA3iV3IQSuPNN2tUY2NFuQlkxPvn
        fp84bicI3rXq7Lo69Lsj3NPrZo9Omex1S/mXl/PBlK+/PPqRWVof6HBSG5xrnXbG
        raYeCmEz7EyuHb/ZRwAvQXkoS32vLM/W01/iRra0ah707z30uk+o1U6fxUYBoqu9
        qlF190AJjDxmflfG1J34rpLk2W7qxmgdCHAC+vwxlrbaZ9NZcmbrno697IGHgMEo
        3QOLCkYgxIq0MRKJEY6zHWDFp0prRLn7lhe5p0UiL57XSJppmqTWBGCQPmWyPGUL
        5w4+/Vk0ljX1Y4R8pW7Y7e5KjBo42zQFyeULITaVj7JCbvUXLYJHbQU6A==
X-ME-Sender: <xms:HuwiZDFH4hyDhFQKZ_RO_GqHQ-_YShmnA0lRB8Gu7l79W3Ka0nMMMg>
    <xme:HuwiZAVycP-FPRPtVcgUZ2wq5LPNaCHxpe2xJn3_Ax7MtQ4AQQx6mea2Jyxd6xR2K
    ljSYlRZXEnlfw>
X-ME-Received: <xmr:HuwiZFJiTTN8ZVbVORu4IVxWnWBcTxgvuk8rbYaHSlsPOM2i4ROHX7Xff9E4WLcPRnRLQOw4ZkBHm81CkHopYxs-zSv8bSRm4NrvmA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvhedrvdehgedgieehucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvfevuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepheegvd
    evvdeljeeugfdtudduhfekledtiefhveejkeejuefhtdeufefhgfehkeetnecuvehluhhs
    thgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorg
    hhrdgtohhm
X-ME-Proxy: <xmx:HuwiZBH1w2I_FZ3ANdRxD85pzVkW8rgOcu9_YIUWYbI5gaiXr0hMKA>
    <xmx:HuwiZJVijAGO85MCdRQRB-UfhP9rZjmZAF2lbpZgJkKe488tAwN5eg>
    <xmx:HuwiZMNzmmFD89mWZI7ONOWhMOesIoaEaKvoT0lIvYbbOFTs1h_D5Q>
    <xmx:HuwiZPzgpPvqe0ftPlmtiti86gFLXUmOvuyApVqEwfAcbFe9mrbzyA>
Feedback-ID: i787e41f1:Fastmail
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 28 Mar 2023 09:31:10 -0400 (EDT)
Date:   Tue, 28 Mar 2023 15:31:08 +0200
From:   Greg KH <greg@kroah.com>
To:     "Limonciello, Mario" <Mario.Limonciello@amd.com>
Cc:     "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "Gong, Richard" <Richard.Gong@amd.com>
Subject: Re: Fix KFD support in GC 11.0.4
Message-ID: <ZCLsHCq46XBG1ZW3@kroah.com>
References: <MN0PR12MB61016FB7B6F4C8AFAE2714F4E2809@MN0PR12MB6101.namprd12.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <MN0PR12MB61016FB7B6F4C8AFAE2714F4E2809@MN0PR12MB6101.namprd12.prod.outlook.com>
X-Spam-Status: No, score=-0.9 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_PASS,SPF_PASS autolearn=unavailable
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Mar 20, 2023 at 09:10:03PM +0000, Limonciello, Mario wrote:
> [Public]
> 
> Hi,
> 
> For a product that has the IP GC 11.0.4, there is a lone error message that comes up during bootup related to some missing support for KFD on kernel 6.1.20.
> 
> kfd kfd: amdgpu: GC IP 0b0004  not supported in kfd
> 
> This is fixed by this series of commits that landed in 6.2 that fixes KFD support on this product (and also fixes a warning).
> 
> fd72e2cb2f9d ("drm/amdkfd: introduce dummy cache info for property asic")
> c0cc999f3c32 ("drm/amdkfd: Fix the warning of array-index-out-of-bounds")
> 88c21c2b56aa ("drm/amdkfd: add GC 11.0.4 KFD support")
> 
> Can you please bring to 6.1.y?

All now qeueud up, thanks.

greg k-h
