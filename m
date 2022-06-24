Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35EEE559545
	for <lists+stable@lfdr.de>; Fri, 24 Jun 2022 10:23:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230239AbiFXIWI (ORCPT <rfc822;lists+stable@lfdr.de>);
        Fri, 24 Jun 2022 04:22:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42534 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFXIWH (ORCPT
        <rfc822;stable@vger.kernel.org>); Fri, 24 Jun 2022 04:22:07 -0400
Received: from mail-lj1-x232.google.com (mail-lj1-x232.google.com [IPv6:2a00:1450:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 219946F7A8
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 01:22:05 -0700 (PDT)
Received: by mail-lj1-x232.google.com with SMTP id s14so1955589ljs.3
        for <stable@vger.kernel.org>; Fri, 24 Jun 2022 01:22:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=iBHxMVGKe3Nq5JC342jgVn2zEkul8NjDVspSHicXRx9fn0p+7TE65BDWuhtuUOm3qM
         RPTG2sJodNL6fjaJ4toLLcc5Me8GDqgWYgzJeteim23grziRWIRkF3G49U5sPPhL5kUD
         ujoIZSri68ZmAc06HpLWymtnM4IzOy9zLI5dd+WjSBc3xiZHA+ML2DVF920C+Rz6219l
         cCfjtLJDTWEA2k8CCmNNW4tLmDIiiJ+sRkYwZXtTjZSEBc3zy09fkkr0czSLNYcyEnJJ
         moRQ1ikaGpBKbbLiF+jzDeRlzO+RPqYWsaP1wnOVrVF3xPVSDd9PLPCl8IqgcsZxBl2n
         BPvg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=aGzvn0q0q9YA/Na0FGp2nMGFn59dA2Gv9fwVzm4epHQ=;
        b=hFLzlLxTrjrZQCLySqMFV+puOPn29BHUGV6RkWQBzB7WUaV1shHX8/fuTmEe/WM8mN
         hO3XkXrzsKqPVfXdiIeSQmlVSHX5dR6WglibcqaNjw/xqEQGoIi+GKwAqLSWHemk9NGr
         QiMu3qM/pH4UUyrHZe2upyKrClj+xV81PsOAc8QqS9okWBnyxCjusGpLhUWVauXakSVY
         F4R1QvZ/9rjw0hBfB6l2rtkIeDoJPKlCSINKJ7rFwUwFZvXzzLNFmeioluDmLnBOEsSy
         bSC7nTxYnNRvJZZYqh/Hqsucm3xgrfaerPvM5folfaEdO5xpX2cGh/WEvIIIOZhaDQ4X
         SECw==
X-Gm-Message-State: AJIora+SspYOsR9VAgkCqUnbZkUMQ3aW0ITfBQ30k3sHGPLVKMJdNTJ5
        5CJjKm1uTU0cVVIfyHtDRAYloYVuod6Dl6vW5bbFX9UcIKgHZA==
X-Google-Smtp-Source: AGRyM1vvII4elIsolZ4aOgyerwxcDo1TOtRWQxieH61lin9F9J1np0umwh6gDYcAWQj3C5DpixNQKbVc2Qf15hAxsxM=
X-Received: by 2002:a2e:9998:0:b0:25a:6d56:3c17 with SMTP id
 w24-20020a2e9998000000b0025a6d563c17mr6958149lji.372.1656058922986; Fri, 24
 Jun 2022 01:22:02 -0700 (PDT)
MIME-Version: 1.0
References: <20220623164322.315085512@linuxfoundation.org>
In-Reply-To: <20220623164322.315085512@linuxfoundation.org>
From:   Fenil Jain <fkjainco@gmail.com>
Date:   Fri, 24 Jun 2022 13:51:51 +0530
Message-ID: <CAHokDB=mS+aJDN+nFO0QsDPS88SR36CxT8dSh5G8kG=dNA4GWA@mail.gmail.com>
Subject: Re: [PATCH 5.18 00/11] 5.18.7-rc1 review
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Shuah Khan <skhan@linuxfoundation.org>, stable@vger.kernel.org
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

Hey Greg,

Ran tests and boot tested on my system, no regression found

Tested-by: Fenil Jain <fkjainco@gmail.com>
