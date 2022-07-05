Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F361B566973
	for <lists+stable@lfdr.de>; Tue,  5 Jul 2022 13:32:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230383AbiGELcz (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 5 Jul 2022 07:32:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231899AbiGELcq (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 5 Jul 2022 07:32:46 -0400
Received: from mail-oi1-x235.google.com (mail-oi1-x235.google.com [IPv6:2607:f8b0:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E89CD167D4
        for <stable@vger.kernel.org>; Tue,  5 Jul 2022 04:32:45 -0700 (PDT)
Received: by mail-oi1-x235.google.com with SMTP id s128so1064582oie.10
        for <stable@vger.kernel.org>; Tue, 05 Jul 2022 04:32:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to:cc;
        bh=7RBDDS+os81yW/KbszAkdackiSF/pB253r0vph85jM8=;
        b=hTTEl/vnjRq9AD2nxPt1K2uC7N323s2BogvEP7Rw2FjDKMOa5hiAqwC7GhWADtCfjF
         ovn9jEk9hCdo4NEVfC01qR58cnaEGZbgocO7rYJamjvpIks2I++LcM4OUtMK6/kKCqo2
         v7x7u75nYWET3VkI8A5jX+nInGYFaEKAWkLlfrvgVtEI1cSX8sQZfFzfM361+HUq8M6u
         5urNXPAAgx0LGlLvssltmpyj/YyupO40UUnEYL3yNBgrw428E5eB3YSGeLX2wRzAnDkd
         nGB9cLdpggXnic0cTUuUoeS3H/d1zMDASbz/szbWpX3agCFLSfuLXtSgxCcbCk+yC11C
         2+xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to:cc;
        bh=7RBDDS+os81yW/KbszAkdackiSF/pB253r0vph85jM8=;
        b=MFlnhuuMR4Kuoh1ESFVRYaCZBGownJDND/1crtzgG1I4mGN29hnvfv/NoPlVoP1Z1m
         nHZYMzZfgDZ3nbnAYMgLroIvBx6+k5vcMSy+ctOKRuWNi/FkEHA4qgIdCYswm5N9ZuBP
         auI27ZU+9gZzEEpUYTJ6awG1RGsqIXKp7+KfBvfLnb+ZvuJy8Ry2XfKSv3ObgUyX6bTI
         ocmRlomdOGRZfT2L+q9cy9aZlrbW/7EE0q8FLoD8ezQ1IwndjOiVW7N+bc8e1Cam6YBx
         wPX8ESEtmaBCKmiySWf2OVXi2PmqUS7XPiJmEOcU9kTclsmUylPGZaI3DRVSNYremhYz
         3LQg==
X-Gm-Message-State: AJIora9+pxqqZCHB0S2sn+sCjpaMwBjtpuRAzZPCH0c/KM5AaQv6hrTy
        1v7sHfc7ddSHhFSZyrDtkn4HgzJHOlUb5SkdeQ6fbesSdgc=
X-Google-Smtp-Source: AGRyM1s5I7K57sDfXewi0CtVT6AGYYSkxqZSSZcLSMQRTcXcUUt2jFpkJ7tvgYplWNvWKQFyUV927zOoKuKmARF2GLw=
X-Received: by 2002:aca:2b0d:0:b0:337:e484:f9da with SMTP id
 i13-20020aca2b0d000000b00337e484f9damr1268268oik.40.1657020764890; Tue, 05
 Jul 2022 04:32:44 -0700 (PDT)
MIME-Version: 1.0
From:   Fabio Porcedda <fabio.porcedda@gmail.com>
Date:   Tue, 5 Jul 2022 13:32:34 +0200
Message-ID: <CAHkwnC9408BG+FBPM1NvrivxcPLf2+Sr_cZ74ir7SB5BrtFebw@mail.gmail.com>
Subject: Backport support for Telit device IDs to 5.15/5.10/5.4/4.19/4.14/4.9
To:     stable@vger.kernel.org
Cc:     Daniele Palmas <dnlplm@gmail.com>, jorgen.storvist@gmail.com,
        Carlo Lobrano <c.lobrano@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi,
Can you please backport the following commits in order to support new
Telit device IDs?

The following one just for 4.9:
commit 1986af16e8ed355822600c24b3d2f0be46b573df
  qmi_wwan: Added support for Telit LN940 series

The following one just for 4.9:
commit b4e467c82f8c12af78b6f6fa5730cb7dea7af1b4
   net: usb: qmi_wwan: add Telit 0x1260 and 0x1261 compositions

The following one just for 4.9:
commit 5fd8477ed8ca77e64b93d44a6dae4aa70c191396
    net: usb: qmi_wwan: add Telit LE910Cx 0x1230 composition

The following one for 4.9/4.14/4.19/5.4/5.10:
commit 8d17a33b076d24aa4861f336a125c888fb918605
    net: usb: qmi_wwan: add Telit 0x1060 composition

The following one for 4.9/4.14/4.19/5.4/5.10/5.15:
commit 94f2a444f28a649926c410eb9a38afb13a83ebe0
    net: usb: qmi_wwan: add Telit 0x1070 composition

Thanks!
-- 
Fabio Porcedda
