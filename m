Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7726A54B04E
	for <lists+stable@lfdr.de>; Tue, 14 Jun 2022 14:18:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356714AbiFNMMh (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 14 Jun 2022 08:12:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356738AbiFNMMY (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 14 Jun 2022 08:12:24 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC6C24A924
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:12:07 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id h187so11345871oif.4
        for <stable@vger.kernel.org>; Tue, 14 Jun 2022 05:12:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=DTrHj3z3bVLU78OVfE5pN3fuYLoIV4eYRGksTv3rLoneCFXPfm+XT5v5Pe+4ZGBiRr
         zKhrmzl5t0Su8Z5rRJ2rEAVD6p8RNziIE+I7qSl/5KeOJbhoqv2qyBVYvu+MAKilynpN
         LOTd8znl6mokXkuAjC5o8RLKd0AHHSo0OAo5R66ySf5Cy9DC5HH5i+5IU/NsHOrjpUj7
         HCEvesLxfjsWFXigucXa1xMELxjCEMU55I5MhPzwNLqobrKVjEgQaCBiQAncjTu6ZOz9
         M8Z2FsYNLyxLRTIxJpN4MBYc2lzYCPPpx4Mno1VtAPshu1iarAef9fQ2oFWdkly2ebSg
         QYyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=lBFrwc11MgcaK75qf3EwNhKoIfwLYz4Dn7scEjO7Hwc=;
        b=6qV9wNQR07B8VoNe6R+oX5oh6fuwAs4/iawKxKhKNWmHCGozwGA82MlNXFMHUVAjrj
         vO3rCT+X6bwaeQFz3u4MOC1z4cO3HjrE64V2Oa7FynYtpj4FTGBsx09EzDQoPr2IBiRJ
         9bAJIaldJD5YlmltfV4O81s2Za557Jk9JtrH8yAtnHe59eA3I5mY07cT6kK/OpoIJdO6
         W1ogob8nfOSVXsCtWin8sL8OOe8GhRTVmQoXHt8MZV3QHQS4iiw3hqTTm6+bWvBCWfAs
         QYw+Hf9DfaSoupYXAAjhYi9Ac4PVQDlhHAMer15uaS6elaEDoGe3XQKn/KTgNdeyvwmy
         6yig==
X-Gm-Message-State: AOAM532wo1ApdLZsCeMi6JEB9IttexHVt1znhx5MOpsSF2YP5dDG1CCE
        ij7MuwwtR2sCVX6OBEXwqutf3JcUtHo1mtblSvp5ZpA3I/g=
X-Google-Smtp-Source: ABdhPJw0fghre3xgkiYD9Pk5t5G7GEH6lMmiGIBemO8qwQh536Nmf10ZiNyOrHCn+FU2TsZPyZ0KA2r78F3C6NvKmR8=
X-Received: by 2002:a05:6808:1a01:b0:32f:284c:5e28 with SMTP id
 bk1-20020a0568081a0100b0032f284c5e28mr1862580oib.194.1655208715981; Tue, 14
 Jun 2022 05:11:55 -0700 (PDT)
MIME-Version: 1.0
Received: by 2002:a8a:c46:0:b0:42d:ab20:ed24 with HTTP; Tue, 14 Jun 2022
 05:11:55 -0700 (PDT)
From:   Daniel Affum <danielaffum05@gmail.com>
Date:   Tue, 14 Jun 2022 15:11:55 +0300
Message-ID: <CAPkju_PekGeuttFyGrBotHTRdWmfD=fDq3+PsRWo528RXwh7rg@mail.gmail.com>
Subject: Confirm Receipt
To:     undisclosed-recipients:;
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=2.5 required=5.0 tests=BAYES_60,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_ENVFROM_END_DIGIT,
        FREEMAIL_FROM,FREEMAIL_REPLY,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no version=3.4.6
X-Spam-Level: **
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hello Dear,

I am Daniel Affum a retired civil servant i have a  business to
discuss with you from the Eastern part of Africa aimed at agreed
percentage upon your acceptance of my hand in business and friendship.
Kindly respond to me if you are interested to partner with me for an
update.Very important.

Yours Sincerely,
Daniel Affum.
Reply to:danielaffum005@yahoo.com
