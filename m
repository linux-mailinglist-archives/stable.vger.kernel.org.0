Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F186F37CE1
	for <lists+stable@lfdr.de>; Thu,  6 Jun 2019 20:59:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727189AbfFFS7H (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 6 Jun 2019 14:59:07 -0400
Received: from out2-smtp.messagingengine.com ([66.111.4.26]:51985 "EHLO
        out2-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726762AbfFFS7H (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 6 Jun 2019 14:59:07 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id D481F21B74;
        Thu,  6 Jun 2019 14:59:03 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Thu, 06 Jun 2019 14:59:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=lfVVPYYE1zv8TPS6RZylhPPQeAB
        r/4SHxam1e1BQ+X4=; b=iCmlnLrgVPO1ZUWYo3Ggic1AWJmeSjmpEGe7KnI/8T4
        +tXaunSDf/9OiKqK8g/Z6/yDAG/wjs4RzzCzLw+hOWHdeEhKggV1Tgam4xZQ27QL
        qtZpMCu4u2RMYchy06qJ+j/2gHirVYlzfDx7kLE46fExO6SlYcwGoNgsyZmwNu9C
        6hyFYPeKMGQNLU5+nCwI47sb5NGnUaFM1ZLEW6+i6UzDDKzwsH2vmfHJT8BBrOf9
        YnvbntTMw304XleX32Dwd8U7p0yHA7aAYYMF7SiOPf9S/EYw1B7zWmjr7kTIMjvb
        yu4vx5ebdrMzEINmsL+7hwhpp/CyuwtOmJDEk4zOm5Q==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=lfVVPY
        YE1zv8TPS6RZylhPPQeABr/4SHxam1e1BQ+X4=; b=194SDOaqYobC0CsuIt+2jK
        Wj0HWqAJxIviRefNsECqxnxvSnlwHaQogNAGsV/bWwlLBo1OCmKNAYX2ffiPDlez
        tuCNTmhewFvVvDKBerMQgIndZzNazJeqSMnGgBQIin/tT2lgmakSn2JDC3+TLnvU
        Z+T43/cJ5ztKx8MXQLLXWRlMzlBlGIsFIq9+aK2NaYzzWKiBw0mum0fY/3L1KG9x
        95urwGUWd9zhtRNgr68YXHqVh+IcJTc3nNzZcA6xTGnn0WTp4OWMxWcE3HJM8Xl4
        EyPcMaQEyUAG282eutxbQpihxkJciATNF1ve4LL3/SmggvKnM65yFFUcU+kVvXyg
        ==
X-ME-Sender: <xms:d2L5XBfeMwlYGwz9hC2V3EKRYt4ivOZdCxhM0k4fKRtwmRKYIM_Qfw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduuddrudeggedgudeffecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujggfsehttdertddtredvnecuhfhrohhmpefirhgv
    ghcumffjuceoghhrvghgsehkrhhorghhrdgtohhmqeenucfkphepkeefrdekiedrkeelrd
    dutdejnecurfgrrhgrmhepmhgrihhlfhhrohhmpehgrhgvgheskhhrohgrhhdrtghomhen
    ucevlhhushhtvghrufhiiigvpedt
X-ME-Proxy: <xmx:d2L5XPJ6MzNiHPBBKqPSXV_858uT_Vc3K3Iy4AP6WSE1AjND0NA0oA>
    <xmx:d2L5XGHjeVAU-PkMgr82QdI4UeOLF4SxOiKgG1hfKNSmMsgq5XroXA>
    <xmx:d2L5XP5KY94tsqMRwicGkSf9-4d4AQn04KL7IUHRbar-6l0yQsEQqA>
    <xmx:d2L5XLzNQCU5xjN2HXb9B8EOyZhr1mM6Cn3pcWg4jx_0vC94E7CgBw>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id E28EB80060;
        Thu,  6 Jun 2019 14:59:02 -0400 (EDT)
Date:   Thu, 6 Jun 2019 20:59:00 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190606185900.GA19937@kroah.com>
References: <259986242.BvXPX32bHu@devpool35>
 <20190606152746.GB21921@kroah.com>
 <20190606152902.GC21921@kroah.com>
 <CANiq72nfFqYkiYgKJ1UZV3Mx2C3wzu_7TRtXFn=iafNt+Oc_2g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72nfFqYkiYgKJ1UZV3Mx2C3wzu_7TRtXFn=iafNt+Oc_2g@mail.gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Jun 06, 2019 at 08:25:28PM +0200, Miguel Ojeda wrote:
> On Thu, Jun 6, 2019 at 5:29 PM Greg KH <greg@kroah.com> wrote:
> >
> > And if you want this, you should look at how the backports to 4.14.y
> > worked, they did not include a3f8a30f3f00 ("Compiler Attributes: use
> > feature checks instead of version checks"), as that gets really messy...
> 
> I am confused -- I interpreted Rolf's message as reporting that he
> already successfully built 4.9 by applying a6e60d84989f
> ("include/linux/module.h: copy __init/__exit attrs to
> init/cleanup_module") and manually fixing it up. But maybe I am
> completely wrong... :-)

"manually fixing it up" means "hacked it to pieces" to me, I have no
idea what the end result really was :)

If someone wants to send me some patches I can actually apply, that
would be best...

thanks,

greg k-h
