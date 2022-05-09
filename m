Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE0B51FF30
	for <lists+stable@lfdr.de>; Mon,  9 May 2022 16:13:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236757AbiEIOO3 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 May 2022 10:14:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236750AbiEIOO2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 May 2022 10:14:28 -0400
Received: from wout2-smtp.messagingengine.com (wout2-smtp.messagingengine.com [64.147.123.25])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB9CB2B1DCC;
        Mon,  9 May 2022 07:10:33 -0700 (PDT)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.west.internal (Postfix) with ESMTP id CBD5D3200921;
        Mon,  9 May 2022 10:10:31 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Mon, 09 May 2022 10:10:33 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=cc
        :cc:content-type:date:date:from:from:in-reply-to:in-reply-to
        :message-id:mime-version:references:reply-to:sender:subject
        :subject:to:to; s=fm1; t=1652105431; x=1652191831; bh=y50qT79R2M
        HZ3HO5JvrJyoh51anmfGJfb+fpKvY3VSU=; b=jf84YbCmS37YqHoT/vJ86QtHM+
        zFpGoDvS/p91zInwfD6mKhtuWUWk/tZO6TJEkA/0LT1kUEyjhE9BQCVbSYUaotlT
        o/KcIM6tCjN+nhN2EJUZt0Ybc9o+kgs/LaVXyVjUr/w8McElYWwCllIVMahN4bM/
        G+k2BSqf5EkKWbzTG5awC50eMoiD1h6Vg96t1+vTcC3ldwAewEoNm0Wii/DA4ujO
        f/fHcAYnSvpJ4gGXC7LRxvkggkoo5CWlXuR1kymMcxjaGQOjZc8xBlyRHuzgi4AT
        2CNWox3VVzXpTrtxayU96RfdH218pHsjvqNuujqTxBjc3iziKMt4XUobIjmg==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm1; t=1652105431; x=
        1652191831; bh=y50qT79R2MHZ3HO5JvrJyoh51anmfGJfb+fpKvY3VSU=; b=j
        AWo7u3mxztZ+nM1HijDOuYLUONacVXSfY3gcaHv1IRt3g85UdFL2WVlIFOokS9GI
        7V6zlyF5HNb6JFgrJu49SYHiWgchNHfJfFzwaH+qBpLuX39yD5ZqxxyatZEvzHiG
        tS2PMi7uVldzPdpCMA4gJ4sq6+gInmMzg2ZeNPKAAFEcuJvva/2c97q+yU+NpDVZ
        5rY0Niif+wiq2w4mdfziybbSdL4sNwwD/9NLr975M/+Q6KFMO57A9GN5v9ligkKK
        HznXWuSx5JYxvI2VchTmgaH1OTblL0krWdrPlGEHZmqKUXc9iw4Ne/arN2Ga498Q
        mJ8GBXYWAhYC3tlUY5V/A==
X-ME-Sender: <xms:1iB5Yj-sWYcGR7731d75rzJLeJjhFjuj8xCUJzre63dC7tjiouaiaQ>
    <xme:1iB5YvsM-eUfAC0R79prR7s3Pty87JMSGUrCsUbTpNmax-tsY-MGSxdCxnmrV8JDT
    hjY6VJEvz8UGg>
X-ME-Received: <xmr:1iB5YhBheEUgpYv2LrOJMX5LwGrrxqjOg32fc9z_t8MHdnjRkuh40OkqxEU8SOeW9bCbq-U46APytXV_4e3O2kycaucJOIlA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvfedrfeelgdejvdcutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvvefukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefirhgvghcu
    mffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucggtffrrghtthgvrhhnpeehgedvve
    dvleejuefgtdduudfhkeeltdeihfevjeekjeeuhfdtueefhffgheekteenucevlhhushht
    vghrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhh
    drtghomh
X-ME-Proxy: <xmx:1iB5YvcfGVt8aB6IL58x6Epa_STwE7MwQ5dpxgXfN07h_qsyA-HaMQ>
    <xmx:1iB5YoNKYkIhaZgQMCnkxxk4H1_H2axTungzXDM_EciWaX7Jk4DwuQ>
    <xmx:1iB5YhkIdl7hDqXDdZV9OoN_9KWqkgUpPF2FTbVYclIU3x0pK40y_Q>
    <xmx:1yB5YklbrCwrzCBQ2KSoRrb0YuCVjVI21fSBDz9k6RQeZxX9a6zyKQ>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 9 May 2022 10:10:30 -0400 (EDT)
Date:   Mon, 9 May 2022 16:09:55 +0200
From:   Greg KH <greg@kroah.com>
To:     Giovanni Cabiddu <giovanni.cabiddu@intel.com>
Cc:     herbert@gondor.apana.org.au, linux-crypto@vger.kernel.org,
        qat-linux@intel.com, stable@vger.kernel.org,
        Adam Guerin <adam.guerin@intel.com>,
        Wojciech Ziemba <wojciech.ziemba@intel.com>
Subject: Re: [PATCH] crypto: qat - set to zero DH parameters before free
Message-ID: <Ynkgs262rVNat0fp@kroah.com>
References: <20220509131927.55387-1-giovanni.cabiddu@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220509131927.55387-1-giovanni.cabiddu@intel.com>
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, May 09, 2022 at 02:19:27PM +0100, Giovanni Cabiddu wrote:
> Set to zero the context buffers containing the DH key before they are
> freed.
> This is a defense in depth measure that avoids keys to be recovered from
> memory in case the system is compromised between the free of the buffer
> and when that area of memory (containing keys) gets overwritten.
> 
> Cc: stable@vger.kernel.org
> Fixes: c9839143ebbf ("crypto: qat - Add DH support")
> Signed-off-by: Giovanni Cabiddu <giovanni.cabiddu@intel.com>
> Reviewed-by: Adam Guerin <adam.guerin@intel.com>
> Reviewed-by: Wojciech Ziemba <wojciech.ziemba@intel.com>
> ---
>  drivers/crypto/qat/qat_common/qat_asym_algs.c | 3 +++
>  1 file changed, 3 insertions(+)

Why isn't this part of the other series for this "driver"?

thanks,

greg k-h
