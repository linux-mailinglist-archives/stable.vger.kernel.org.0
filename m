Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 743644E5832
	for <lists+stable@lfdr.de>; Wed, 23 Mar 2022 19:13:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239993AbiCWSPY (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 23 Mar 2022 14:15:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238955AbiCWSPX (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 23 Mar 2022 14:15:23 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FCAF4ECC0
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:13:54 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id z8so2475776oix.3
        for <stable@vger.kernel.org>; Wed, 23 Mar 2022 11:13:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:reply-to:from:date:message-id:subject:to;
        bh=Z0szFu8s6DGJqIhZ3dTeWXKtueRzB4LGmWYNg4eDNjk=;
        b=Pw96VHpBN9pckY8/ViT73bu6A9KdI9dwSgnZdCsVpxbhOtv7XLL4QbTvklvDKOxTjK
         7my/VdO0bTICcqavQ1+i+1VcmcqtzHPcZY+/4jQnW9/Z25XKuaumAwIdCIX6beFVNfyt
         M6qjON84RPkCePJiBkjTPWXn4nHQ3vgSilqrf00QE62hN9H4FMZtS4Lcyr7p0uK9BB0b
         e0kjVo5yWp0IE1BzTIGD8UQfg7gg0vdtV6h3ZFVHcZ5Wa8juuY9Dy2LCL44HQXLI0Ftm
         RhU1c+9kbPYJhXt+762FoVRb33PWMEq3XEWoVcM2pZdqOpKhSbv/K/2/OjqbS0igGqMi
         I43Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:reply-to:from:date:message-id
         :subject:to;
        bh=Z0szFu8s6DGJqIhZ3dTeWXKtueRzB4LGmWYNg4eDNjk=;
        b=mdajo9+VcoSsU4/Gr6o3n8hhgNTk1+QvJBdEXRu3RzBOPSd/DAL5X2oarmw4phGHtF
         NaXfBvd9xB25TMCfpi+iz0wYd0Z23wkqIR4vXW93mxvh+Q/+3NsmdOqqjhCeXsascgF7
         /81V3wP9stZo104CpDMOsPVduwhabqhjMUu7fhiljxGR+ewMRci0fe4ueg6NyfdZXhx7
         aHTCAAQ/D0nzBMwxgmIXkfaAnbs0paKXmbuwC5l9Dy2jXlq23B99le+LM/IUlZN2BDLD
         vN561ohGverXjvJrOLSrwytz5wS2zakpyXknQk+z9BaSlhH5oTWl3TL3L1FDVclmlGjb
         6AVA==
X-Gm-Message-State: AOAM53080dBv8dOehrM/GzCqurey4W+dazlU+UceX0+zvStRsnppt5Gt
        /ZstZ1zmlQTcb+7BBe3965NZ4THvqq1ei+scadU=
X-Google-Smtp-Source: ABdhPJzho8H8RBEbi1B5vrFaBQPjWAWT/CXf8x24UbfulkQwgmk7CoHAJCEb9EmVdwWcZudNTHfmm847Lt7UAHK4m1o=
X-Received: by 2002:a05:6808:df1:b0:2ec:b193:ad6c with SMTP id
 g49-20020a0568080df100b002ecb193ad6cmr5114060oic.200.1648059233441; Wed, 23
 Mar 2022 11:13:53 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a05:6838:f1c5:0:0:0:0 with HTTP; Wed, 23 Mar 2022 11:13:53
 -0700 (PDT)
Reply-To: pm2956161@gmail.com
From:   philip moore <contact.donkalidon@gmail.com>
Date:   Wed, 23 Mar 2022 11:13:53 -0700
Message-ID: <CAGXj=C6XPnNvtdHCvwX15_M9++B_awmBTU9PBggOQUi_QN2pEg@mail.gmail.com>
Subject: Urgent
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=4.8 required=5.0 tests=BAYES_20,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,FREEMAIL_REPLYTO,
        FREEMAIL_REPLYTO_END_DIGIT,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,UNDISC_FREEM autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Level: ****
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello,


Hope you are safe?



Please did you got my previous message.


kindly let me know.


Thanks
