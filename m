Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 781B05F7901
	for <lists+stable@lfdr.de>; Fri,  7 Oct 2022 15:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229933AbiJGNaX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+stable@lfdr.de>); Fri, 7 Oct 2022 09:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiJGNaW (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 7 Oct 2022 09:30:22 -0400
Received: from mail.astralinux.ru (mail.astralinux.ru [217.74.38.119])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3E5A5A3D4;
        Fri,  7 Oct 2022 06:30:18 -0700 (PDT)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 4345938629ED;
        Fri,  7 Oct 2022 16:30:10 +0300 (MSK)
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10032)
        with ESMTP id DPVhyZ6N5ULc; Fri,  7 Oct 2022 16:29:57 +0300 (MSK)
Received: from localhost (localhost [127.0.0.1])
        by mail.astralinux.ru (Postfix) with ESMTP id 1876638629BD;
        Fri,  7 Oct 2022 16:29:57 +0300 (MSK)
X-Virus-Scanned: amavisd-new at astralinux.ru
Received: from mail.astralinux.ru ([127.0.0.1])
        by localhost (rbta-msk-vsrv-mail01.astralinux.ru [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 1H5dKxmWl2H1; Fri,  7 Oct 2022 16:29:56 +0300 (MSK)
Received: from work-laptop.astralinux.ru (unknown [10.177.20.36])
        by mail.astralinux.ru (Postfix) with ESMTPSA id EC35B38629B9;
        Fri,  7 Oct 2022 16:29:55 +0300 (MSK)
From:   Andrew Chernyakov <acherniakov@astralinux.ru>
To:     acherniakov@astralinux.ru,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Mathieu Poirier <mathieu.poirier@linaro.org>,
        linux-arm-msm@vger.kernel.org, linux-remoteproc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        stable@vger.kernel.org, lvc-project@linuxtesting.org
Subject: [PATCH 5.10 0/1] rpmsg: qcom: glink: replace strncpy() with strscpy_pad()
Date:   Fri,  7 Oct 2022 16:29:30 +0300
Message-Id: <20221007132931.123755-1-acherniakov@astralinux.ru>
X-Mailer: git-send-email 2.35.1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
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

Link: https://lore.kernel.org/all/20220519073330.7187-1-krzysztof.kozlowski@linaro.org/

Found by Linux Verification Center (linuxtesting.org) with SVACE.
