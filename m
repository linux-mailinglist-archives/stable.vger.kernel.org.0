Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 44A51549B20
	for <lists+stable@lfdr.de>; Mon, 13 Jun 2022 20:09:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238684AbiFMSI5 (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 13 Jun 2022 14:08:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245269AbiFMSIl (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 13 Jun 2022 14:08:41 -0400
Received: from mail-ed1-x536.google.com (mail-ed1-x536.google.com [IPv6:2a00:1450:4864:20::536])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E278819AD
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:57:56 -0700 (PDT)
Received: by mail-ed1-x536.google.com with SMTP id n28so7261711edb.9
        for <stable@vger.kernel.org>; Mon, 13 Jun 2022 06:57:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=wdPPl7JGix3xqbYjPABtiE957eLzuh/6aKzl2Ms37ug=;
        b=Wmj0vI6Ic6OKXPkKaNQfRmmHWg2eX537hwZGVj/dufczDHTl2LDAIdg6YXtq8Gzkrv
         QUtEJnzfRmkwuwPZ8NKgtNhRFKMG0xc5ufulDwirJBB3jetbSP+7bkzssOjwyCNXn7qV
         6DfxJJe8BazsKylidbHVyn8lkbZZ571wXOsMAX4xbCGX/cILeL2ah1Vn1QNU9B4Ei0fr
         mpYLY2ZttkksGkU09nZvekXQ3rTbkX7732w9IquYmpLColcuyUjW48zTDfQ5xIg8uiIY
         JbTq9BhaqaEASHS2mVYF0Zrhd6otyc+a/pi7Q3AERmSgEc7Ytc7guTR+b1LabowwwKY9
         qdng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=wdPPl7JGix3xqbYjPABtiE957eLzuh/6aKzl2Ms37ug=;
        b=6x1VonBBn/T5fEwuNbOJP0u8Sn++qNFHzod7YNXynmjQMyTegXVaqPjREQYaSDmLF5
         y/u27wmkFGNX8dZQtPIA3YF6zImrQZiLqt8Z9Ycl2vX5sIUCRA36wH9WZ0+p72ZHcUyv
         5KSVrx5k9zq997O2wBtBnKlnI3P83xBgIxnJsQKoOlChyuA+etqe1Qx4ECVMEWwziFGf
         jrnbNjppJe5p3qIVC/h1ZRFoMcw3L+l4kFPkISHWOFNuxbgeivne5MTaN3d+O8ncr8Uq
         gMPJ9GQpV1gmI0DWIdq4pNsvYhFkFiTCLhkgHBZ+HmBQFVfgGIMQN5EKENvKDwfFUoY3
         ogIg==
X-Gm-Message-State: AOAM5312VLpqmTxXGDIUprsZxJy522ZYg8zjBmoBGCxhVwMiiMalW8tB
        8Pwx+hkzWiAx/GLLlBgntNQlXMNIQzKE5UwnIYl+Mbi8Vk8=
X-Google-Smtp-Source: ABdhPJyO+pBLtAkRSGNqX/3yna/47oc4qXdD+QpO8XfEVHL7U9az5fDqSicaQaYLilsaTvXYWVDa6BkGJ7WN7iqXKaI=
X-Received: by 2002:a05:6402:3310:b0:42d:e77b:fef0 with SMTP id
 e16-20020a056402331000b0042de77bfef0mr64913759eda.193.1655128674919; Mon, 13
 Jun 2022 06:57:54 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 13 Jun 2022 08:57:44 -0500
Message-ID: <CAHCN7x+XOObNu=Hemz+B3gP8c5-sGu28goSw-=yPH1b5B_KwUQ@mail.gmail.com>
Subject: arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3
To:     stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please port 4ce01ce36d77 ("arm64: dts: imx8mm-beacon: Enable RTS-CTS on UART3")
to 5.10+

This fixes an issue where attempting to use hardware handshaking on
the DB9 port fails.
