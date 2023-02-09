Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ECF9D6913AC
	for <lists+stable@lfdr.de>; Thu,  9 Feb 2023 23:46:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229939AbjBIWqs (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 9 Feb 2023 17:46:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48100 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230414AbjBIWqp (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 9 Feb 2023 17:46:45 -0500
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA80C6591
        for <stable@vger.kernel.org>; Thu,  9 Feb 2023 14:46:43 -0800 (PST)
Received: by mail-pj1-x1036.google.com with SMTP id d2so3460646pjd.5
        for <stable@vger.kernel.org>; Thu, 09 Feb 2023 14:46:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=paul-moore.com; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=9g2yQtWzAVH6ZOpDsD/Sskemui/XDqoYgj9fWj/hkxU=;
        b=Fcjg1IeCP5a42XMH+PhI6FfYg/ZEC4FgpEwO2V6GvMNyMrvAcl9kKvcS01KBHSx82+
         OZZKtrI7t5/KX66FOK/1hHFW0nVKD4IBJf/vEIg9028FjBGjeq+MxlG8wtJRbGXCe8Zv
         ssz7dnJgd1z50RC8sOXXUWNvCagc3zNzWh7y6NFro6FvBBXOx3hjqr8K9oWb616ub3vD
         nXXLKpIF4/k+oT2CQZYhei6jOVDegdDoUAyaqgD8+2AB3UMhfTdFu+tjTrdWCiYHd/UC
         /CDS2BY/9+s5PZrlNrGdQPNrWzw61I1u1EAxVPSdCY2ZXwyX7YgR1ABL5UcgKsWMwx8r
         KwzQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=9g2yQtWzAVH6ZOpDsD/Sskemui/XDqoYgj9fWj/hkxU=;
        b=6nGYBh9FgE9jK2VIfMQBsZm9tOuErvSYtP61b94tHyD7eNeRVjMvmqRdiokHdGMnUq
         FW8YYWCOgt+JCViVp9dZ27iK2Yqz37WktEJlbXyvldnCZXLYn7+m7tHOU/WGYVg3O340
         ZuXdLaLWAfEXnVSGIw3MMXUwaKsNdB2Jv59HqkbLlh+3hGS98ZgvunO9g7eMETG94Xhw
         7Izyet7rhGwlx04bawTpPbg3yzEtW1VIfhARRjYAR5hcBshWsK9iKaHUj6jVGcVS9oyN
         g0JyAKTfY186PIAEF1Oz/SXfV64xB/bx1s9/p8QDjPuEG84dvSIWnYWGbBkDJd9sZyvr
         py1A==
X-Gm-Message-State: AO0yUKVBH8xv9TeaCtwN9I7m5dOWvorfxoFbnf9qBy+x30i1wMNtyvBM
        Vknk0xpfknocg8Mefi7lqNe+FI0VxidW6ZoYOIJq
X-Google-Smtp-Source: AK7set+5+CGbyUdx+XEn7CyiOAlZsrmdC59etIZEgrVyrqoicPNTGQjjG1Gn3JnsMH+LPETc4+h+vPAftTT77wQ7BnQ=
X-Received: by 2002:a17:902:70c4:b0:198:ff55:2ef3 with SMTP id
 l4-20020a17090270c400b00198ff552ef3mr3307989plt.27.1675982803339; Thu, 09 Feb
 2023 14:46:43 -0800 (PST)
MIME-Version: 1.0
References: <20221227142740.2807136-1-roberto.sassu@huaweicloud.com>
 <20221227142740.2807136-3-roberto.sassu@huaweicloud.com> <Y64XB0yi24yjeBDw@sol.localdomain>
 <d2a54ddec403cad12c003132542070bf781d5e26.camel@huaweicloud.com>
 <857eedc5ad18eddae7686dca63cf8c613a051be4.camel@huaweicloud.com> <Y+VBMQEwPTPGBIpP@gmail.com>
In-Reply-To: <Y+VBMQEwPTPGBIpP@gmail.com>
From:   Paul Moore <paul@paul-moore.com>
Date:   Thu, 9 Feb 2023 17:46:32 -0500
Message-ID: <CAHC9VhTYeqCB8roaNvWUYJeKPwT35ixJ8MMXBe0v0+a9o8CXWw@mail.gmail.com>
Subject: Re: [PATCH v5 2/2] KEYS: asymmetric: Copy sig and digest in public_key_verify_signature()
To:     David Howells <dhowells@redhat.com>
Cc:     Roberto Sassu <roberto.sassu@huaweicloud.com>,
        Jarkko Sakkinen <jarkko@kernel.org>,
        Herbert Xu <herbert@gondor.apana.org.au>, davem@davemloft.net,
        zohar@linux.ibm.com, dmitry.kasatkin@gmail.com, jmorris@namei.org,
        serge@hallyn.com, linux-integrity@vger.kernel.org,
        linux-security-module@vger.kernel.org, keyrings@vger.kernel.org,
        linux-crypto@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, Roberto Sassu <roberto.sassu@huawei.com>,
        Eric Biggers <ebiggers@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Feb 9, 2023 at 1:53 PM Eric Biggers <ebiggers@kernel.org> wrote:
> On Thu, Feb 09, 2023 at 11:49:19AM +0100, Roberto Sassu wrote:
> > On Fri, 2023-01-27 at 09:27 +0100, Roberto Sassu wrote:
> > > On Thu, 2022-12-29 at 14:39 -0800, Eric Biggers wrote:
> > > > On Tue, Dec 27, 2022 at 03:27:40PM +0100, Roberto Sassu wrote:
> > > > > From: Roberto Sassu <roberto.sassu@huawei.com>
> > > > >
> > > > > Commit ac4e97abce9b8 ("scatterlist: sg_set_buf() argument must be in linear
> > > > > mapping") checks that both the signature and the digest reside in the
> > > > > linear mapping area.
> > > > >
> > > > > However, more recently commit ba14a194a434c ("fork: Add generic vmalloced
> > > > > stack support") made it possible to move the stack in the vmalloc area,
> > > > > which is not contiguous, and thus not suitable for sg_set_buf() which needs
> > > > > adjacent pages.
> > > > >
> > > > > Always make a copy of the signature and digest in the same buffer used to
> > > > > store the key and its parameters, and pass them to sg_init_one(). Prefer it
> > > > > to conditionally doing the copy if necessary, to keep the code simple. The
> > > > > buffer allocated with kmalloc() is in the linear mapping area.
> > > > >
> > > > > Cc: stable@vger.kernel.org # 4.9.x
> > > > > Fixes: ba14a194a434 ("fork: Add generic vmalloced stack support")
> > > > > Link: https://lore.kernel.org/linux-integrity/Y4pIpxbjBdajymBJ@sol.localdomain/
> > > > > Suggested-by: Eric Biggers <ebiggers@kernel.org>
> > > > > Signed-off-by: Roberto Sassu <roberto.sassu@huawei.com>
> > > > > ---
> > > > >  crypto/asymmetric_keys/public_key.c | 38 ++++++++++++++++-------------
> > > > >  1 file changed, 21 insertions(+), 17 deletions(-)
> > > >
> > > > Reviewed-by: Eric Biggers <ebiggers@google.com>
> > >
> > > Hi David
> > >
> > > could you please take this patch in your repo, if it is ok?
> >
> > Kindly ask your support here. Has this patch been queued somewhere?
> > Wasn't able to find it, also it is not in linux-next.
> >
>
> The maintainer of asymmetric_keys (David Howells) is ignoring this patch, so
> you'll need to find someone else to apply it.  Herbert Xu, the maintainer of the
> crypto subsystem, might be willing to apply it.  Or maybe Jarkko Sakkinen, who
> is a co-maintainer of the keyrings subsystem (but not asymmetric_keys, for some
> reason; should that change?).

It is problematic that David isn't replying to this.  I have no idea
if it will work, but I just reached out to him to see if I can draw
his attention back to this ...

--
paul-moore.com
