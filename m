Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 935D6597045
	for <lists+stable@lfdr.de>; Wed, 17 Aug 2022 15:58:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239685AbiHQNyG (ORCPT <rfc822;lists+stable@lfdr.de>);
        Wed, 17 Aug 2022 09:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45310 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231609AbiHQNyF (ORCPT
        <rfc822;stable@vger.kernel.org>); Wed, 17 Aug 2022 09:54:05 -0400
Received: from mail-vs1-xe36.google.com (mail-vs1-xe36.google.com [IPv6:2607:f8b0:4864:20::e36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E92CF95AC0
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 06:54:03 -0700 (PDT)
Received: by mail-vs1-xe36.google.com with SMTP id n125so6935026vsc.5
        for <stable@vger.kernel.org>; Wed, 17 Aug 2022 06:54:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:from:to:cc;
        bh=/gzITbBOSXEpQZ+33UkvJIctPu7Cvz10am8YtntRnMQ=;
        b=Ftju2V92TkX7UZ4xXURCsR49mrq3yc+x1GqeQkBkf9glx2SlYHQ7eDMrgwdhK8ESit
         WtNXODpN+cnjq2eZM5wNAKhESWM01l9vraKdWMInBdiMALuZQKH81GsZEi/By4H1yrg3
         OIViZb3shWNmcqBRW5rKPF12SYc2rsYehprl/crU1mXgwHqDPL5SdNj7ycwrl4mo8OW4
         aoOw2CdyP6vTJPGVPtkMgaNd1B9Z+fMWh/lSEVTrmyFrEAfbFu7G5v8mXe0m51de6QC4
         +d/PF7JziGnoxRKhHwwB/t3h5teXDLkC2AMo9vpqJjrleaYQbatqpQVhW/PPI5IjhNLd
         LMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:to:subject:message-id:date:from:sender
         :mime-version:x-gm-message-state:from:to:cc;
        bh=/gzITbBOSXEpQZ+33UkvJIctPu7Cvz10am8YtntRnMQ=;
        b=Bg3oBngut8+Lm9uYaE0PrCu53jdsD8l/koOH+5GqTLMRWdaOUEAmVLIWaP5ekAssJC
         P+r4uEEESLNOinrm70h4FDkUSoGkKNPyUq3aE709apQltfHz2KveKQ111twGCq+hDrVt
         Lg7agCE8Ke2SW7W5y43nHIkf3zyMXkTEVENP5aezLe+He/qSiyCCtQt1XeDoBFTrPy39
         eFKI8TjghrsDzsK+EHYVFbBTCeCJe382L9k8AslqIc4RbkOQ5j5qZbs2LMuJSNi1x7zq
         ggLfCiE+eDfQeKYybRMwp7K7UQcrI38HOgQrhXc14KpGT7MLnaXPse2pgt3lAJBT4lhv
         H2Ng==
X-Gm-Message-State: ACgBeo1/yUKsIIoo+iq+XJxuLbuutkNL4LE/rlIDWcZ7pxVs3jaJKbN8
        73B/GyrTSsn6+N0qCVdoIe/vCkW23ku6sNSMa6U=
X-Google-Smtp-Source: AA6agR4hYdbdV4FSM2H9re1q0AsP8tVfGa+eeEx95MrXrRhhZ4I4wkyJ8jYYb5/cM2uWn5wbsLO99AMvYjg5kLpdD18=
X-Received: by 2002:a67:d487:0:b0:385:1a6b:6f33 with SMTP id
 g7-20020a67d487000000b003851a6b6f33mr10465908vsj.59.1660744443003; Wed, 17
 Aug 2022 06:54:03 -0700 (PDT)
MIME-Version: 1.0
Sender: ftobch268@gmail.com
Received: by 2002:a59:a746:0:b0:2e3:84b9:72b9 with HTTP; Wed, 17 Aug 2022
 06:54:02 -0700 (PDT)
From:   Pavillion Tchi <tchipavillion7@gmail.com>
Date:   Wed, 17 Aug 2022 13:54:02 +0000
X-Google-Sender-Auth: o56Lw59oXr1KBkZA8QjzjgigQl4
Message-ID: <CAM3WQrZiAp7rFB4SrnS1EuqcpXRB4zCA+CLuhuPGGT0_8=Kv4A@mail.gmail.com>
Subject: Ahoj
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

--=20
Ahoj
Obdr=C5=BEeli jste m=C5=AFj p=C5=99edchoz=C3=AD e-mail?
