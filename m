Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3F3D966B5
	for <lists+stable@lfdr.de>; Tue, 20 Aug 2019 18:47:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729137AbfHTQrJ (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 20 Aug 2019 12:47:09 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:56103 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726663AbfHTQrJ (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 20 Aug 2019 12:47:09 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id 83E0B21F7D;
        Tue, 20 Aug 2019 12:47:07 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 20 Aug 2019 12:47:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=MoIsF4nwZnVzrh4dF4rG+VSxIdO
        oDRzzi1WljiY0Zi0=; b=fV0gCAJKFRFPF1/x57U/wwXI/ar87SJ3kv9A3Xcd4CQ
        cJ31eK/itKx0k1T8Qw75V1u3g9nFFOqxs+qZUMaYLftFRXcd5CjpbRcOz9ZgN68O
        bzR+KKC0lZ3pUafK9kA70fYQqd4y6yTA9ceE+po4p6lvJ1j5TRdf6Tq6zusVLrTU
        DHZghDahfQxjU0lY443Q42lstwKa0wLbhkap5rqoDWLgmBwpvLuaD92aQ8Umhz5R
        pyB4wJas6YYqgP+wDAg3LxKt0p2xqvFf8uUyhaViE2ALEY1XN/3CiURnFsKh0cIr
        q+avfyAsLQpf5jH9FlknlDBhlcRYfUIy+TVApJcoBLA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=MoIsF4
        nwZnVzrh4dF4rG+VSxIdOoDRzzi1WljiY0Zi0=; b=D4CyPesjalIFjzc/oN9uiD
        ovJu0jZUo4MZwIHk2H1cUAS8Gq4r2lhE8SyjisgH+Osa0wm/K2juvuylYf9DDZq0
        5erYmgENV5PqhOZeVqiPHeV+vQHX1pCb41fL5NzJH1T5hjLtZ0YOvBfRgFwcbPXR
        2u3W0q3CT2siB9eb28jBWeGkepV83+dGBR8ykRombBerb7TNWynRyJYV/LTR8LOw
        IDSzCsTsIvuXpouEv9fdqiqXT8uHsLWtPKx4vtvf5gM5CZArxxFpOgw+G51KDRKl
        Z8+zgnuxf64GNtxSUyt1mM+y8zqgJoBRhp2EhG0K3K1ssTNFBUti3ZDeoGmCWFVQ
        ==
X-ME-Sender: <xms:CiRcXQLPJMc7wE_OXbtun2com1eYyqwCkaiGpCVZiREAVNIJHmAo3Q>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddrudeguddguddtvdcutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepudekgedrudekkedrfe
    eirddvnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:CiRcXUblpA93vQaiSkCNYMys_xA8SkBxo0gFbG1CKPY9FGAH4jbtqA>
    <xmx:CiRcXbtvZaGJ4cteQecaZ_yKSKQfUYaE6-0ReSqcEPndwn0uo0KsBQ>
    <xmx:CiRcXRue9ROwTzdwftd6Qq1RWMieF3iZlS208GT61jASW0qKlN3bCQ>
    <xmx:CyRcXRULQJNl0Ogkhn5Y5gZdriyFTo0bq2-NM1tZatjtNQhxctAfdA>
Received: from localhost (wsip-184-188-36-2.sd.sd.cox.net [184.188.36.2])
        by mail.messagingengine.com (Postfix) with ESMTPA id 488828005A;
        Tue, 20 Aug 2019 12:47:06 -0400 (EDT)
Date:   Tue, 20 Aug 2019 09:47:04 -0700
From:   Greg KH <greg@kroah.com>
To:     Luca Coelho <luca@coelho.fi>
Cc:     stable@vger.kernel.org
Subject: Re: [PATCH 5.2] iwlwifi: Add support for SAR South Korea limitation
Message-ID: <20190820164704.GA26395@kroah.com>
References: <20190820133251.9555-1-luca@coelho.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190820133251.9555-1-luca@coelho.fi>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, Aug 20, 2019 at 04:32:51PM +0300, Luca Coelho wrote:
> From: Haim Dreyfuss <haim.dreyfuss@intel.com>
> 
> commit 0c3d7282233c7b02c74400b49981d6fff1d683a8 upstream.
> 
> South Korea is adding a more strict SAR limit called "Limb SAR".
> Currently, WGDS SAR offset group 3 is not used (not mapped to any country).
> In order to be able to comply with South Korea new restriction:
> - OEM will use WGDS SAR offset group 3 to South Korea limitation.
> - OEM will change WGDS revision to 1 (currently latest revision is 0)
> 	to notify that Korea Limb SAR applied.
> - Driver will read the WGDS table and pass the values to FW (as usual)
> - Driver will pass to FW an indication that Korea Limb SAR is applied
> 	in case table revision is 1.
> 
> Signed-off-by: Haim Dreyfuss <haim.dreyfuss@intel.com>
> Signed-off-by: Luca Coelho <luciano.coelho@intel.com>
> ---
> 
> This is needed in v5.2, because the FW API has changed and this patch
> is needed to support this new version.  The new version was backported
> to our FW version 46, which we didn't predict at the time when the
> patch was committed to the mainline, but it needs to be taken now in
> order to avoid a regression.

Now queued up, thanks.

greg k-h
