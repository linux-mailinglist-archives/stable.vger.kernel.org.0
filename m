Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEC9A1E1F78
	for <lists+stable@lfdr.de>; Tue, 26 May 2020 12:16:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731765AbgEZKQH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 26 May 2020 06:16:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:46982 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726944AbgEZKQG (ORCPT <rfc822;stable@vger.kernel.org>);
        Tue, 26 May 2020 06:16:06 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CCFCC2071A;
        Tue, 26 May 2020 10:16:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590488166;
        bh=DzkBbf5oeb0cdW/wBmldy6tJQZjMEl25csjKMddYnIg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=yZXVYDMwFyOehlszO1skMSh1i+h/5sEoMPwspgXHpC8k3/QQFMt3DrpNM3W3/MUmv
         o0BjSup1f2WZNzuWf82VDHZXpDpIIfENe2npzqEclr3Rjr0gQyLdR9t98+h9OKRPtf
         OVO/lXIBLdJ0HZkW1fVSLDuTMVO3t7jR9Hszdrkk=
Date:   Tue, 26 May 2020 12:16:04 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     "Longpeng (Mike, Cloud Infrastructure Service Product Dept.)" 
        <longpeng2@huawei.com>
Cc:     Markus Elfring <Markus.Elfring@web.de>,
        linux-crypto@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Gonglei <arei.gonglei@huawei.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        Corentin Labbe <clabbe@baylibre.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [v2 2/2] crypto: virtio: Fix use-after-free in
 virtio_crypto_skcipher_finalize_req()
Message-ID: <20200526101604.GB2759907@kroah.com>
References: <20200526031956.1897-1-longpeng2@huawei.com>
 <20200526031956.1897-3-longpeng2@huawei.com>
 <0248e0f6-7648-f08d-afa2-170ad2e724b7@web.de>
 <03d3387f-c886-4fb9-e6f2-9ff8dc6bb80a@huawei.com>
 <8aab4c6b-7d41-7767-4945-e8af1dec902b@web.de>
 <321c79df-6397-bbf1-0047-b0b10e5af353@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <321c79df-6397-bbf1-0047-b0b10e5af353@huawei.com>
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Tue, May 26, 2020 at 05:24:03PM +0800, Longpeng (Mike, Cloud Infrastructure Service Product Dept.) wrote:
> 
> 
> On 2020/5/26 17:01, Markus Elfring wrote:
> >>>> … Thus release specific resources before
> >>>
> >>> Is there a need to improve also this information another bit?
> >>>
> >> You mean the last two paragraph is redundant ?
> > 
> > No.
> > 
> > I became curious if you would like to choose a more helpful information
> > according to the wording “specific resources”.
> > 
> > Regards,
> > Markus
> > 
> Hi Markus,
> 
> I respect your work, but please let us to focus on the code itself. I think
> experts in this area know what these patches want to solve after look at the code.
> 
> I hope experts in the thread could review the code when you free, thanks :)

Please note that you are responding to someone who is known to be a pain
in patch reviews and has been blocked by many kernel
developers/maintainers because they just waste people's time.

I suggest you all do the same here, and just ignore them, like I do :)

thanks,

greg k-h
