Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA775466DB
	for <lists+stable@lfdr.de>; Fri, 10 Jun 2022 14:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237231AbiFJMvP (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 10 Jun 2022 08:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236639AbiFJMvN (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 10 Jun 2022 08:51:13 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 62A5661616
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:51:09 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id y12so25182610ior.7
        for <stable@vger.kernel.org>; Fri, 10 Jun 2022 05:51:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GB+YOSu6orQvesTHFIByXENYgfE+D6jINtoaBYx8Wys=;
        b=WY99pdmiZYc1twU7Izbi1kZbuYrlKk5urY0WpUtXpUup1U23AAxmqmH91S+cYhxIHR
         TghvVqAOsr0MgUm70xRn7g/Ov+EqwUeh/+WLgKUg+I1d7fFiSfIpSQOiRfF136IoTnUW
         5KEmEpM5SqxM4GKuxPPFy5NufDYY0/QojZo9vI7BKYav4+xe2+cwGL9yuXAs5qdw0jzS
         Sc0FDRz7REPe0Im2oipTsoRkP5Cvb9u5TUiyw1RkrEHHDdOY4eODqbAMlKTO9bVlaRBb
         S054BKcY6A30pOyYyPDDb0RBLc+lAmLmcg/uRu5U44FyScRpbDmEU5opnEjZc9OwrWE8
         +v8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to
         :content-transfer-encoding;
        bh=GB+YOSu6orQvesTHFIByXENYgfE+D6jINtoaBYx8Wys=;
        b=tAnYE4yKFRggStcdKihhSh7y/BujhB+CHOCkofC60gLrQWAwQ6P/BoSxHShzKBDUB7
         DTRa9MtsQluHWagP/VSCPvCZbaQ82+MEZ/G61iJPwnkylyRrhewLLybFr6NMkY+7iYDB
         ZyMX9lcYaKgmY6fWAfmQL7F0RohvES8GrE5HcN9FC2Y5Gg/utctxKsh8L/g5sU+krJNX
         BJiG2DgnSPftaIiVF0I9fVvU0ylYkbd3WEfPVZD/5UMP5ElS7Mzi/LOae94lQjfHggKu
         fu4cHFauqylxS/0DQ+epDWgupE/FpoXP1xLWuUo3omZbWCIyQcE5UXT7WoFna6/Bi+Wg
         pU/A==
X-Gm-Message-State: AOAM530cvwoguUV2O7Qw9t8ZlesAO+JVJcPYINkiKu2e0s07if1Wz9Ua
        Z/yQZXqPEIDl18/ukManDdysbEjojso6WhnztqkBDw==
X-Google-Smtp-Source: ABdhPJwlHhsNrG/ENSlY3WhRdsZczYuLTiFF5Wu9YjPjFW7v6f1WT4UIncrFiDyhptO/mXUGIVTfOMBY6U6SJvwX3h4=
X-Received: by 2002:a05:6638:168a:b0:331:9c9a:90b4 with SMTP id
 f10-20020a056638168a00b003319c9a90b4mr16189773jat.236.1654865468433; Fri, 10
 Jun 2022 05:51:08 -0700 (PDT)
MIME-Version: 1.0
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <maze@google.com>
Date:   Fri, 10 Jun 2022 05:50:55 -0700
Message-ID: <CANP3RGezxyXRmX3_cuXksjjcNkzbi+EOe7biMQRAdroV9DMhkA@mail.gmail.com>
Subject: 4.9 LTS inclusion request for "net: fix nla_strcmp to handle more
 then one trailing null character"
To:     Greg Kroah-Hartman <gregkh@google.com>,
        Sasha Levin <sashalevin@google.com>, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
        ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED,USER_IN_DEF_DKIM_WL,
        USER_IN_DEF_SPF_WL autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please pull into 4.9 LTS:

https://gitlab.arm.com/linux-arm/linux-power/-/commit/2c16db6c92b0ee4aa61e8=
8366df82169e83c3f7e
"net: fix nla_strcmp to handle more then one trailing null character"

+++ lib/nlattr.c
@@ -379,7 +379,7 @@ int nla_strcmp(const struct nlattr *nla, const char *st=
r)
-       if (attrlen > 0 && buf[attrlen - 1] =3D=3D '\0')
+       while (attrlen > 0 && buf[attrlen - 1] =3D=3D '\0')

which appears to be present in 4.14.233 (and presumably newer LTS),
but not in 4.9:

$ git log --oneline -n1
remotes/linux-stable/v4.14.233..143722a05028ebb8691d349007f85656a4e90a8e

We've got some code that is confirmed failing due to the lack of this one-l=
iner,
and the fix is obvious enough...

(assuming it applies it presumably wouldn't hurt in 4.4 LTS either,
but I think that tree isn't even maintained, and I don't care about it
there)

Thanks,

Maciej =C5=BBenczykowski, Kernel Networking Developer @ Google
