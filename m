Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8E6FA5508B8
	for <lists+stable@lfdr.de>; Sun, 19 Jun 2022 07:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231939AbiFSFOi (ORCPT <rfc822;lists+stable@lfdr.de>);
        Sun, 19 Jun 2022 01:14:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229611AbiFSFOh (ORCPT
        <rfc822;stable@vger.kernel.org>); Sun, 19 Jun 2022 01:14:37 -0400
Received: from mail-oa1-x2f.google.com (mail-oa1-x2f.google.com [IPv6:2001:4860:4864:20::2f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDB0011A37;
        Sat, 18 Jun 2022 22:14:36 -0700 (PDT)
Received: by mail-oa1-x2f.google.com with SMTP id 586e51a60fabf-fe023ab520so10291019fac.10;
        Sat, 18 Jun 2022 22:14:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+Gt78r/GydQGVOlcadXM6q5AeGPQsy5JksHaVTuKE88=;
        b=ihvm+pVhyu6P3ch/ijF15Co3z9/PM41RZSqhgFYQ2D9xc4RPC2yIZfqYQar+4XW/uH
         c2HomqVml092DqDr0+EfkBsu5fHJ+ZMMr0W16vOQ9PXaomwp7cDyIx9UTplPbeqxZOod
         3dzKyLYtGSn3A8I2lLYWES4nxHr5tjJ+ZfJvvV0lW+2ZqNhs+GbJEYyhr36Ei6PjiY2K
         AuyNZ4mpr0JJiD9hnlj2iFMRm5WChTthpASfvX2pRsbVZCqxDavqm3fxpTKmXEaBzOea
         7c7N++NhX8uX1sRF/uRfQqeevIqlc4d+UdhdYscWL+jfxgOw6A6BIscJjdw8EHZVuwRc
         nZlQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+Gt78r/GydQGVOlcadXM6q5AeGPQsy5JksHaVTuKE88=;
        b=r4qv2gzExnlF1xpsJPVAGNHJ1188Sr5BZfWj+JELQd3mLXHVJrgG4YGVZkEhBXVAzo
         gUesDJviPEuifsmuzK7moYNHd/+12/frpU6gRuTfXO2AxVG6JNxF9tzXC256ElkqO06V
         pezFAt9/dGs4G+Ya0T1718LB21a3RNXdQBCnmPI1RkhwqADZ4UPduhbJDzwTPgrIhigd
         zkuK6bXtLzpMQ1bEcXOknQFswg90++3F20ykKaswtyG+6GDWmb0Hn3MESoIdwJ5gpwsy
         esM2hHxB5ns9KCCJSO74h87lsiadYY0McFB92a550l+6qhLdyJlohwwPbyFtYqr9CzJZ
         tFpA==
X-Gm-Message-State: AJIora8NPbVoxYhnIYc9V8ZTC5LtIwwvi9atZ8Jc0+IZWfgeTmEyy5Bb
        Qw70T3IKzxiTGEyaanlbB9DklHbQZ/oM9vDaJAoNzRk0Fk4=
X-Google-Smtp-Source: AGRyM1vF68WYGspU6W6nP3tHqxysPEZHPol5yAGhcwq5qx+2FM3QTeu6q+fZUoyS3En/AgM+sjI3OH6eVcS2SzFKqL0=
X-Received: by 2002:a05:6870:3309:b0:f5:d369:d126 with SMTP id
 x9-20020a056870330900b000f5d369d126mr15023131oae.98.1655615676125; Sat, 18
 Jun 2022 22:14:36 -0700 (PDT)
MIME-Version: 1.0
References: <20220618133712.8788-1-gch981213@gmail.com>
In-Reply-To: <20220618133712.8788-1-gch981213@gmail.com>
From:   Chuanhong Guo <gch981213@gmail.com>
Date:   Sun, 19 Jun 2022 13:14:24 +0800
Message-ID: <CAJsYDVKy8xaWEq6u=JqtFJwrtNyQYdDW-fhTRWUj04fD9c56ug@mail.gmail.com>
Subject: Re: [PATCH] ACPI: skip IRQ1 override on Lenovo ThinkBook 14G4+ ARA
To:     linux-acpi@vger.kernel.org
Cc:     stable@vger.kernel.org, "Rafael J. Wysocki" <rafael@kernel.org>,
        Len Brown <lenb@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
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

Hi!

On Sat, Jun 18, 2022 at 9:37 PM Chuanhong Guo <gch981213@gmail.com> wrote:
> +static const struct dmi_system_id irq1_edge_low_shared[] = {
> +       {
> +               .ident = "Lenovo ThinkBook 14 G4+ ARA",
> +               .matches = {
> +                       DMI_MATCH(DMI_SYS_VENDOR, "LENOVO"),
> +                       DMI_MATCH(DMI_BOARD_NAME, "LNVNB161216"),

This is a terrible match. Lenovo uses this board name everywhere.
I should match DMI_PRODUCT_NAME = 21D0 instead.
I'll send a v2 later.
-- 
Regards,
Chuanhong Guo
