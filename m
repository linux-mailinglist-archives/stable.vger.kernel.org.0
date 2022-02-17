Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BBC3E4BA306
	for <lists+stable@lfdr.de>; Thu, 17 Feb 2022 15:32:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238989AbiBQObu (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 17 Feb 2022 09:31:50 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:57018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236140AbiBQObt (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 17 Feb 2022 09:31:49 -0500
Received: from mail-qv1-xf36.google.com (mail-qv1-xf36.google.com [IPv6:2607:f8b0:4864:20::f36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E9B42AED80
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 06:31:33 -0800 (PST)
Received: by mail-qv1-xf36.google.com with SMTP id c14so8498614qvl.12
        for <stable@vger.kernel.org>; Thu, 17 Feb 2022 06:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linuxfoundation.org; s=google;
        h=date:from:to:subject:message-id:mime-version:content-disposition;
        bh=gI+nCpVbhWVWoSuzKKcmxXUkDQLKBhWZzNkH22Esq50=;
        b=Khw66a/Q4Y+wWN3sh7jBR4s7qF1EsS8vDjcDh0vt+Y/ugPDLWUCOmRVYDQ21HdJaBo
         NHsywABcmEBI0teBgdDPH2JVmzgiXbnRkN0E8oKAAMHA9+PbmzJIr15HnmTmvPSmpbP4
         a2LQ5xjhm/57J/8VnOPpfhLwJ/9tM4ymIos0s=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:mime-version
         :content-disposition;
        bh=gI+nCpVbhWVWoSuzKKcmxXUkDQLKBhWZzNkH22Esq50=;
        b=u6dK6rbr19SLuN8aPcmBm9QJtHPZ6oBMmyA/ydtpjcBfT+YRak8WhrdO2hP8X2XFOP
         wRuu5ZRZFXB+/mBdPQZYkrLyDa5YCOsmB2jD8+AfWrencEMet5p4CWgMImp/t5uMsL8l
         njhYUThuacmIsv4/psGlfgB1jTMjKKrsKQWP9YKfzg4Gm7N4y4A1rkWIZiGePTr9Xr2K
         vUi1KWTOUhjM/4J2XlSHfKQyvMry1Kni3ufxUVS18l0sGeHaggVe7BWi3rRUpi+chQZ8
         vdTUv+7xMe3Zro4qJfDOeZ9bIoB3EYREX9B+eb8Pu9r+CTiloxSn+JfT5DhSBAB/Wjdm
         Au7w==
X-Gm-Message-State: AOAM533xSCtfLTBK6gl+ey+87hMFTm9gRdrpRo6FzsYsdlrt1AyLKwJU
        1B4KlxdQcGpwKtIhR92tAFJfTLmbJt2apQ==
X-Google-Smtp-Source: ABdhPJwb9rv4S/d3e3Bgp1OoBsT6N9IkdIat62p8GhFWJ1KXMFHMUkZ6O5yyIncjzpgLvjJL9EMHmw==
X-Received: by 2002:a05:6214:21ef:b0:42c:b910:a61e with SMTP id p15-20020a05621421ef00b0042cb910a61emr2277975qvj.34.1645108292644;
        Thu, 17 Feb 2022 06:31:32 -0800 (PST)
Received: from meerkat.local (bras-base-mtrlpq5031w-grc-32-216-209-220-127.dsl.bell.ca. [216.209.220.127])
        by smtp.gmail.com with ESMTPSA id bp18sm14906202qtb.72.2022.02.17.06.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Feb 2022 06:31:32 -0800 (PST)
Date:   Thu, 17 Feb 2022 09:31:30 -0500
From:   Konstantin Ryabitsev <konstantin@linuxfoundation.org>
To:     linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Removing unsupported branches into stable-historic.git
Message-ID: <20220217143130.ie63qha4ghaqx4sp@meerkat.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
X-Spam-Status: No, score=-2.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi, all:

What do you think about deleting unsupported linux-x.x.y branches from the
stable/linux.git repository (perhaps by moving them into stable-historic.git).
These branches hold a lot of git objects that are now largely dead weight but
are still shipped around every time stable/linux.git is cloned.

According to my cursory tests, dropping unsupported branches would remove
1.1GB of obsolete objects, dropping the repository size from 3.5GB to 2.4GB
(sizes may vary in your tests due to compression, window size, etc). That's
1.1GB less traffic for each stable/linux.git clone.

Thoughts?

-Konstantin
