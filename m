Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0115F6EE3A1
	for <lists+stable@lfdr.de>; Tue, 25 Apr 2023 16:08:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233702AbjDYOIo (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 25 Apr 2023 10:08:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230192AbjDYOIn (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 25 Apr 2023 10:08:43 -0400
Received: from mail-wr1-x435.google.com (mail-wr1-x435.google.com [IPv6:2a00:1450:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE58794
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 07:08:42 -0700 (PDT)
Received: by mail-wr1-x435.google.com with SMTP id ffacd0b85a97d-2f4c431f69cso3536202f8f.0
        for <stable@vger.kernel.org>; Tue, 25 Apr 2023 07:08:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1682431721; x=1685023721;
        h=to:subject:message-id:date:from:mime-version:from:to:cc:subject
         :date:message-id:reply-to;
        bh=hDsECoPtk2JyFQBIVPjLtUxIY7uY3zUWDLOXhR3+vPE=;
        b=ngiPfUIbgNKeZLb+C+ww5xyXAwu/fVPyMHnKLVQ4Dbgsom4FA2iEPeEQ24p6vcigWE
         v4XegHr8/ewK+A2vB/vaxzG1SXxLOgTzn0C7iYutMWktQWFNhW3D0NsC0QqL9MsVDYGL
         howF0nAbYN7TRP9B6fIZOijT697xSbrCi0hTDJoBDPGaah+/+UJ1DRZnnE/PiXL0cBd/
         XE+n7xjn6F2Saqchol1OAR9pMDvWlbtz9iplhiTkhyVjtYEsZTeVzazAfnWADDNqHcn9
         EDtQvhJFIE9HoxT6u9OnRti5o1GjExfKrutENWDi9yLc0eZS+ZE2Q/4zbvfJa1uUSphA
         pDfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1682431721; x=1685023721;
        h=to:subject:message-id:date:from:mime-version:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=hDsECoPtk2JyFQBIVPjLtUxIY7uY3zUWDLOXhR3+vPE=;
        b=XCQtU4nQK3GAJcFbUSVqwdHhPnfwOuno4gwh344EnaQM/an8fgatdq8pmkFz34XgK/
         HYhxYdOpeiOolMmv1KXG11IBeV9cA2MuEXM0L7EA/ezxo/O2R9T/dPFBcAMJpe0zos6o
         MAetGg1AtCwB1QZz/dZsPJAthAauMpU1/q8hjnUrkJXnIvT37DI5QzOqiLeh9BY8jU+q
         lOoB5Ga/Xhf+V1p0xrmfKPyjmjEZJlO5JtR5TtBYTv+FJP4XOyV5dxZvnOMbnhCplFUL
         z+ITIjujpFHXbDzR0m+2bLGkoLT5CqaiQsPg4e91YE7RUFWzyypKVHf7MBWIpk/ovdE2
         cb8g==
X-Gm-Message-State: AAQBX9fIjlT/b1HkdLXHmgSOWJn7WpMQiq5ngN1j2qRp4RPzRfwna2oy
        KfcX5tUS7VrYsDkZi1hiMyHAT9tsNc/V4z8ptMB8iCmh/8E=
X-Google-Smtp-Source: AKy350Yc+xC685l26t4VSHRL01zunP6Of2TaC2Oq1737LaAxwKtEKw3qHJkl+GP6szWvDaTe8n+6S8mBLVEVU+cxLyI=
X-Received: by 2002:adf:ec90:0:b0:2f0:27cc:1e7 with SMTP id
 z16-20020adfec90000000b002f027cc01e7mr11388201wrn.9.1682431721167; Tue, 25
 Apr 2023 07:08:41 -0700 (PDT)
MIME-Version: 1.0
From:   Kristof Havasi <havasiefr@gmail.com>
Date:   Tue, 25 Apr 2023 16:08:30 +0200
Message-ID: <CADBnMvgH1H_+WNSdQ=hJp15v4jh0nwFZVkggeiCSWaFHtzORJQ@mail.gmail.com>
Subject: Does v5.4 need CVE-2022-3566 and CVE-2022-3567 patches
To:     Greg KH <gregkh@linuxfoundation.org>,
        Sasha Levin <sashal@kernel.org>, stable@vger.kernel.org
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

Hi there,

I was evaluating CVE-2022-3567 and CVE-2022-3566 which both
revolt around load tearing and reference an ancient Kernel commit:
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")

I am not sure whether they are applicable to the v5.4.y branch as well.

Could you advise?
Best Regards,
Kristof Havasi
