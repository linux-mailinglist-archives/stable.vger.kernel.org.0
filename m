Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBA875F7717
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 12:52:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229658AbiJGKwa (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 7 Oct 2022 06:52:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58256 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229454AbiJGKw2 (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 06:52:28 -0400
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1CBA74E35;
        Fri,  7 Oct 2022 03:52:24 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id EE0BD3140AD9;
        Fri,  7 Oct 2022 13:43:01 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id fSDMqfgQr799; Fri,  7 Oct 2022 13:43:01 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 6FAC4314001C;
        Fri,  7 Oct 2022 13:43:01 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Cohsg_jf7vM0; Fri,  7 Oct 2022 13:43:01 +0300 (MSK)
Received: from work-laptop.astralinux.ru (unknown [10.177.20.36])
        by mail.astralinux.ru (Postfix) with ESMTPSA id 8E5863140957;
        Fri,  7 Oct 2022 13:43:00 +0300 (MSK)
From:   Andrew Chernyakov <acherniakov@astralinux.ru>
To:     acherniakov@astralinux.ru, stable@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] Backport of rpmsg: qcom: glink: replace strncpy() with  strscpy_pad()
Date:   Fri,  7 Oct 2022 13:41:19 +0300
Message-Id: <20221007104120.75208-1-acherniakov@astralinux.ru>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

With static analisys tools we found that strncpy() is used in rpmsg. This
function is not safe and can lead to buffer overflow. This patchset
replaces strncpy() with strscpy_pad().

This patchset backports the following commit from v5.16:
commit 766279a8f85d ("rpmsg: qcom: glink: replace strncpy() with strscpy_=
pad()")

Link: https://lore.kernel.org/all/20220519073330.7187-1-krzysztof.kozlows=
ki@linaro.org/

Found by Linux Verification Center (linuxtesting.org) with SVACE.
