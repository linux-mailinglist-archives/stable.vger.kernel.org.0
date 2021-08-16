Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8303ED7F8
	for <lists+stable@lfdr.de>; Mon, 16 Aug 2021 15:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230177AbhHPNyu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 16 Aug 2021 09:54:50 -0400
Received: from wnew4-smtp.messagingengine.com ([64.147.123.18]:50369 "EHLO
        wnew4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230071AbhHPNys (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 16 Aug 2021 09:54:48 -0400
Received: from compute1.internal (compute1.nyi.internal [10.202.2.41])
        by mailnew.west.internal (Postfix) with ESMTP id 0D4BB2B01258;
        Mon, 16 Aug 2021 09:54:14 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute1.internal (MEProxy); Mon, 16 Aug 2021 09:54:15 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:content-transfer-encoding:in-reply-to; s=fm1; bh=9
        4uyQ/Y3UGrErl2d7WvNOsT3dUU8l/TaaASeFSuZ4wQ=; b=NEttHJfIQq8CeT46E
        LjAMXnaiIs7D72771ZpXr7rNg6VUZjBIenPKwshF2OA2Zzed002Ljbt9IexsRFKd
        Y/IvLURs5A2iWlX7NjCZsMqpMR/96sxF00WQxAdvMJK9LQdCUDUAMAu16ndQscxf
        3Yt/1OCkruhLDh5N7HI3kOoopDku+ebk2RgpPiSd2qLMx32QfLbGEeOK8Wu6Jk6G
        qdXqp2SeR4LinYi7Eb0jMaEhST+UmadU9RKM2WXEn/ptAMgmBpBObtJDlrZx+gYF
        V7aAl4TPtzFDYiCmsF7av2RI0y+cXmC3oEdcsR5uTPhbI643spBWfSKjh1IoK/U/
        nu7bQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=94uyQ/Y3UGrErl2d7WvNOsT3dUU8l/TaaASeFSuZ4
        wQ=; b=JmZYa7HUS2u05avuWAnQ9DIWW3iCEQKD2rjsd+4WrBP7UuIrnQAGGoXwF
        zTH8ZnGDxTYMYaXU5Hbw5wv1o5T41nlZ/lakIwQf7obkCvxgegFdW6fHotD2eX6w
        LO4gCRtZpvzYHHgZJ2YAjKDF9cB1PaGPrRHNdMMlHCdHrY0pAS21YU+mvjwOP3eo
        VmNhwfD3a9C5qRDN2KXkkhV53OqASF82f5ByneFM//ljOjDZBy08HSnJm/w95xIe
        4+ImYdXT0zaqH5DMjcxPoO+mUdizA3Wjv75RbImA7zxO6DnaB3lTBAC8+gOpYzXh
        73O5E6Cgtk/jzrDlUE7EWHvomj4/A==
X-ME-Sender: <xms:BW4aYbghGjNE4_J5ffeLTFIn24NX9SkjrQdZKB8qzX29rFXepZOKIg>
    <xme:BW4aYYDHASr-FTNf2oEyFH_4zK9L_p1SNhxQ1FBZ9p4369ahIFJp7bCIQpjhxl08o
    pyc8ayLDHGctw>
X-ME-Received: <xmr:BW4aYbFJX13NPf3G2kX1t32fJw7cqYWiJYqkP9sRfJCrfO7PgzJ_jowst_jRc6xfnmP2VGIQPk-38orpBZ1zAxOC9tYw4hhn>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrledugdejtdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggugfgjsehtkeertddttddunecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpedvfffgue
    eiuefhheevheetgfehvdefgeekfeevueejfeeftdetudetiefhheffvdenucffohhmrghi
    nhepkhgvrhhnvghlrdhorhhgnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpe
    hmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:BW4aYYTS1g-ZYn49QssyLIQqfEwT9q1p8odn_teWUZR32Q_bp6x6Qw>
    <xmx:BW4aYYz-jYUMlhGI3XXk9CGj4zay8cIuBWyrMg_R_AXbCvWV0Yd8WQ>
    <xmx:BW4aYe7FHQJfGd92O1wkgeL6MSH2AuvdbkTT-FV9jNuGjWDxT-9BWg>
    <xmx:Bm4aYdpL4WxU3vHiCA-dI0p33F_DNt1GIKkTy6cN45zM0_1OrtJX4OQcaf4>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 16 Aug 2021 09:54:13 -0400 (EDT)
Date:   Mon, 16 Aug 2021 15:54:03 +0200
From:   Greg KH <greg@kroah.com>
To:     Pali =?iso-8859-1?Q?Roh=E1r?= <pali@kernel.org>
Cc:     stable@vger.kernel.org, Johannes Berg <johannes@sipsolutions.net>,
        Sasha Levin <sashal@kernel.org>, Luca Coelho <luca@coelho.fi>,
        linux-wireless@vger.kernel.org
Subject: Re: [PATCH] mac80211: drop data frames without key on encrypted links
Message-ID: <YRpt+5BI0WlTQ5dP@kroah.com>
References: <20200327150342.252AF20748@mail.kernel.org>
 <20210816134424.28191-1-pali@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210816134424.28191-1-pali@kernel.org>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Aug 16, 2021 at 03:44:24PM +0200, Pali Rohár wrote:
> From: Johannes Berg <johannes.berg@intel.com>
> 
> commit a0761a301746ec2d92d7fcb82af69c0a6a4339aa upstream.
> 
> If we know that we have an encrypted link (based on having had
> a key configured for TX in the past) then drop all data frames
> in the key selection handler if there's no key anymore.
> 
> This fixes an issue with mac80211 internal TXQs - there we can
> buffer frames for an encrypted link, but then if the key is no
> longer there when they're dequeued, the frames are sent without
> encryption. This happens if a station is disconnected while the
> frames are still on the TXQ.
> 
> Detecting that a link should be encrypted based on a first key
> having been configured for TX is fine as there are no use cases
> for a connection going from with encryption to no encryption.
> With extended key IDs, however, there is a case of having a key
> configured for only decryption, so we can't just trigger this
> behaviour on a key being configured.
> 
> Cc: stable@vger.kernel.org
> Reported-by: Jouni Malinen <j@w1.fi>
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> Link: https://lore.kernel.org/r/iwlwifi.20200326150855.6865c7f28a14.I9fb1d911b064262d33e33dfba730cdeef83926ca@changeid
> Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> [pali: Backported to 4.19 and older versions]
> Signed-off-by: Pali Rohár <pali@kernel.org>

Now queued up, thanks!

Did not apply to 4.4.y, don't know if you want it there or not...

thanks,

greg k-h
