Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0564539C55
	for <lists+stable@lfdr.de>; Wed,  1 Jun 2022 06:48:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349552AbiFAErN (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 1 Jun 2022 00:47:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349551AbiFAErM (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 1 Jun 2022 00:47:12 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A68933E26
        for <stable@vger.kernel.org>; Tue, 31 May 2022 21:47:09 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a10so888550pju.3
        for <stable@vger.kernel.org>; Tue, 31 May 2022 21:47:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:sender:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=oXjrioDnfpdscFTPhwe5eTP8raXbbRL+txchizTdKpg=;
        b=WdoRIbOrYEXF6zEdbAtSmAqFRg3c/tMNHiZOasbUCPPGLeJvP8vABqXo308AI7Y9Mh
         0a5PycrOJtUz1Y9TzfJ8qdGj2lMTknQOU8zOoWtxDU4ODfWd2ej5VvbB0veJ8V5I+b7b
         Jcqm6CCN77/YIB1wxzrZLe09oCyKC7EMcBVsGSUgaMbP7czdr6glNYm69bhhrqS36KKa
         rX2K+Cjcb1IURcRZlknSNyD79SBZANvDLlGA6Yw9Q98AOD/THjuOBCkf5NnmfTVJrclW
         YJT3A9/V3i17/lozUh0UfAuLdnG5McOxkVP1hP7Q8+Og+qHnoJjYwPDgZxdnvlqiVueN
         RE/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:sender:from:date:message-id:subject
         :to:content-transfer-encoding;
        bh=oXjrioDnfpdscFTPhwe5eTP8raXbbRL+txchizTdKpg=;
        b=p2gCNOUOLM/yXUqaBi/H/Iv9pdRREgu/+vKclXFjv3VK/wjlABTKGHv2N25MWUMLU9
         dW6cC1IdIRJPqFyFFPA95zvgLfE8sJ+UZAM3C9GPjziTPkV3rKdQtjzyDceWY+CrSxYw
         xL8nxr9GVqjsIA3WyAGOtYSU2g5Ay0PaC8h5sFkUIFLWu320ShanHs6+wJxz6bs3CURQ
         jsjZJ4ii+e4dWC/uuXc7FhoAcH5gwaZcutmmbTB0niP3eHRdCW1oYHdtzUjAZP+Jddfx
         heGiGoqyYPSdZOh22PivAHKknopxiZQyuVx6CbSIqxEmjR8iPaD4I9dYGySOwL6kWa4U
         mdYQ==
X-Gm-Message-State: AOAM533hhh5RO7j9jvzA/OtBGeyQo6gcglaGp4dfrT69MRA34yKKT55s
        jK7ST9tfgj5fmVBOOVrbeOQHaa8Ges7nUSZwDIg=
X-Google-Smtp-Source: ABdhPJzjg2CCj5hCAEqtrBzHU9+JfecrNwO2SfNmMVF5/1Ys8Fb9/MgF3Eb1PoKfLJrFfMABENOTvozKZM+qqTRjX4A=
X-Received: by 2002:a17:90b:46c6:b0:1e3:524c:7f94 with SMTP id
 jx6-20020a17090b46c600b001e3524c7f94mr3826004pjb.177.1654058828777; Tue, 31
 May 2022 21:47:08 -0700 (PDT)
MIME-Version: 1.0
Sender: aklessopessetoki90@gmail.com
Received: by 2002:a05:7022:d5e:b0:40:a50c:fdb3 with HTTP; Tue, 31 May 2022
 21:47:08 -0700 (PDT)
From:   Kayla Manthey <sgtkaylamanthey612@gmail.com>
Date:   Wed, 1 Jun 2022 04:47:08 +0000
X-Google-Sender-Auth: _vYdzJPz4DO25bQQid5gMo6FzM4
Message-ID: <CAL_1YZkAn=YgTzqn7-MYcSn8CSd=7Y7-sxNTv81ROOyRLQ+E6g@mail.gmail.com>
Subject: 
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=0.8 required=5.0 tests=BAYES_50,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Bonjour, je n'ai pas encore re=C3=A7u de r=C3=A9ponse de votre part concern=
ant
mes deux e-mails pr=C3=A9c=C3=A9dents, veuillez v=C3=A9rifier et me r=C3=A9=
pondre.

Hallo, ik heb nog geen feedback van je ontvangen met betrekking tot
mijn twee vorige e-mails, controleer en beantwoord me.
