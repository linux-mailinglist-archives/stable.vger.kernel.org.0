Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B0BA181882
	for <lists+stable@lfdr.de>; Mon,  5 Aug 2019 13:55:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727357AbfHELzo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 5 Aug 2019 07:55:44 -0400
Received: from out3-smtp.messagingengine.com ([66.111.4.27]:43207 "EHLO
        out3-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727259AbfHELzo (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 5 Aug 2019 07:55:44 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.nyi.internal (Postfix) with ESMTP id A90C82148D;
        Mon,  5 Aug 2019 07:55:42 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Mon, 05 Aug 2019 07:55:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm1; bh=WrDb4esL3ajy5ujNajPOSkPy+aY
        Xl4b5J03jgIi8A30=; b=l2Pu8MVcAiEwRA3W0qQaombT2nsBgFeFEoQMNqpsJbh
        RgT3MCY+MiEuFaJ3HDN8eI30hLKOwzdpb4jwpf0+Tan/FT4LUDjL35HJ4sxMMZ8M
        jbg5glDUZ17SEnb/Q4cogPaXa6NVxlrQ7TU45sokJDP/Y6dvuDPP2E094bks3tRi
        9QfajSGuiJw9FFqKr9WB/weCzpF9YL5Ajt2EAgCT2tHv7p07X21lkv75LC28s8yE
        armMlxITchCXBSasH7zPw99Wnyw0ZyRxsbgWlhbNLa3Y8SVGYmh76I1lHzgHYhvN
        z6epxdz6O6SSNs0+hHukH6O8ljI78IvzOYRAymKt+PQ==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=WrDb4e
        sL3ajy5ujNajPOSkPy+aYXl4b5J03jgIi8A30=; b=iaoTftYeGg62YeE9iY3jQ/
        Bw+8PRR/Tyy3uSerrx87LSRGV3y9fezeytzcSxQnZZ/qU8BxMdSF/PHcphneoCPr
        FBYkZDbx+mw7KjU+oXJLlg4O8yN3juZSWpE9an5bHGpWx6KiBC5vDyA2Zgzth9Lz
        hLeGqSWolHZ+Va9Zpfws+OAmlDPo49l5CDO5id6h3E4TcpOKEc685kIY5EMEu5Ea
        OAV5aQjei/VBd8SGtjBCAWwCEBwcYFr/Zu4jcxkx/+C2AettZbKaiS/fqYlWkk64
        5NzLrlxM0XlXbSGrmYvuFWl3si0cx2/m70zYn7o3NeqS8KJd5Ka+Hlip6UDXrIsQ
        ==
X-ME-Sender: <xms:PhlIXUIeReZuy51-E2xDo0yJwqGJyEpIihly7OKrqaQHI3UlduAZZw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgeduvddruddtjedggeeiucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjfgesthdtredttdervdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecukfhppeekfedrkeeirdekledrud
    dtjeenucfrrghrrghmpehmrghilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhmnecu
    vehluhhsthgvrhfuihiivgeptd
X-ME-Proxy: <xmx:PhlIXbQ0EnPU4uz71IWF72Cbs_9NdpdYJL73UC0GqNX9MvMP-cmeng>
    <xmx:PhlIXXD_ocstRIYGwUYYvlBL4iWg1miIsXdh5Gz4B6uOqyDfJJdfBQ>
    <xmx:PhlIXaIF-nOpV6rBhU77WyYTaIauXZdxq91sXWTtezKxuxoteVqm3g>
    <xmx:PhlIXTMTFGu49LMlP_CDrR5UJNKyzy1affuIzOUtF3Vi2aPIjtTcEQ>
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        by mail.messagingengine.com (Postfix) with ESMTPA id DEA3C380085;
        Mon,  5 Aug 2019 07:55:41 -0400 (EDT)
Date:   Mon, 5 Aug 2019 13:55:40 +0200
From:   Greg KH <greg@kroah.com>
To:     Miguel Ojeda <miguel.ojeda.sandonis@gmail.com>
Cc:     Rolf Eike Beer <eb@emlix.com>, stable@vger.kernel.org,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: Linux 4.9.180 build fails =?utf-8?Q?wi?=
 =?utf-8?Q?th_gcc_9_and_'cleanup=5Fmodule'_specifies_less_restrictive_attr?=
 =?utf-8?Q?ibute_than_its_target_=E2=80=A6?=
Message-ID: <20190805115540.GB8189@kroah.com>
References: <20190606185900.GA19937@kroah.com>
 <CANiq72n2E4Ue0MU5mWitSbsscizPQKML0QQx_DBwJVni+eWMHQ@mail.gmail.com>
 <4007272.nJfEYfeqza@devpool35>
 <CANiq72=T8nH3HHkYvWF+vPMscgwXki1Ugiq6C9PhVHJUHAwDYw@mail.gmail.com>
 <20190802103346.GA14255@kroah.com>
 <CANiq72kcZZwp2MRVF5Ls+drXCzVbCfZ7wZ8Y+rU93oGohVAGsQ@mail.gmail.com>
 <20190802112542.GA29534@kroah.com>
 <CANiq72mSLmP-EaOgY0m2qgTMVsAnyE6iuW5Kjdw5mSy1ZH0y-A@mail.gmail.com>
 <20190802155627.GB28398@kroah.com>
 <CANiq72k-2Gtb8Q_f2Nhy6aud-QwuSiJ8oEJbwt-pjd+bs8qDVg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANiq72k-2Gtb8Q_f2Nhy6aud-QwuSiJ8oEJbwt-pjd+bs8qDVg@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Fri, Aug 02, 2019 at 06:55:53PM +0200, Miguel Ojeda wrote:
> On Fri, Aug 2, 2019 at 5:56 PM Greg KH <greg@kroah.com> wrote:
> >
> > I see a ton of warnings on those kernels today.  I'll look into it next
> > week after I apply your patches to see what's missing.
> 
> Yeah, the objtool ones -- I thought you were referring to the
> -Wmissing-attributes that Rolf asked about (I am not sure why Rolf has
> those as -Werror rather than warnings, though).
> 
> I can take a look at the objtool ones and see if applying some of the
> patches helps, although I have never looked into how objtool works, so
> no promises :)

I think I got it working now, all looks good for 4.9.y, 4.14.y and
4.19.y for gcc9 so far.  I'll leave 4.4.y alone :)

thanks,

greg k-h
