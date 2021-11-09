Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DD58844B274
	for <lists+stable@lfdr.de>; Tue,  9 Nov 2021 19:07:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242171AbhKISKH (ORCPT <rfc822;lists+stable@lfdr.de>);
        Tue, 9 Nov 2021 13:10:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50348 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241890AbhKISJg (ORCPT
        <rfc822;stable@vger.kernel.org>); Tue, 9 Nov 2021 13:09:36 -0500
Received: from mail-ot1-x32e.google.com (mail-ot1-x32e.google.com [IPv6:2607:f8b0:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 675D0C061767
        for <stable@vger.kernel.org>; Tue,  9 Nov 2021 10:06:47 -0800 (PST)
Received: by mail-ot1-x32e.google.com with SMTP id w6-20020a9d77c6000000b0055e804fa524so3701136otl.3
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 10:06:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=O+fhYkcqhMQ8k14bNZcPRV6UkOwVHbARh5DBR4w4Kpg=;
        b=CPnbviPehHndJcufAKnxvmQCz4mp4bEQpdeHccnDuhigP6kyJib/gphfqJKMBD9sYN
         oez1oJmgZmzZ9XoEAsKiegEc6B939nNhVcBQpeUfDIlRCKzPMyNeltxhWg23GOET6xug
         ceiQT9g16XrsJlHxHY1H3O2rBE2zM0ITmzCjE=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=O+fhYkcqhMQ8k14bNZcPRV6UkOwVHbARh5DBR4w4Kpg=;
        b=IfVQ2YMaTSravqOjwmJTVUvl+UizJ6AZHsejS2v/RJgfDlG24tRpY1pYhU5LX/9Ong
         N2pm5gv+HwTnjhniLpSwUL34zV9HkCoiz2db+Cz6CXlSV9EH4DwrpPBBNXJx4OtR1/7t
         l9bERIUiVlW9HuMCOpFRq95wQHmpUT2f95KP2ePNoKVAMV+XwdOyetFW35Q9pZ52iCbd
         RNAWloulsp7AOUcqQM5abUYOk+hmbdxZXjxVh7b3fVbbbQP2yzaGhxQcH1pNE/izPEUI
         T3xNaIvTQl3FtCpKoA554mD1DPF66B39LG/8QmhGZXBriwZ1w0w8kWxkY529zVM1T76o
         j86Q==
X-Gm-Message-State: AOAM533ePKs09rcOPHB8O/LNkzN61mErW/rcBRRsQ5KC1rIv+R994un5
        tbVLUjEQw7YVpVkeyTv3RmLvwyPo+vYFhA==
X-Google-Smtp-Source: ABdhPJymElRtuF0rDeRNJiCaGRgogFTaholViC4rrFvygNRtD+ncbA8/bn2lFtBXK95CB4pKqgzGDQ==
X-Received: by 2002:a05:6830:1c74:: with SMTP id s20mr7449924otg.384.1636481206572;
        Tue, 09 Nov 2021 10:06:46 -0800 (PST)
Received: from mail-ot1-f42.google.com (mail-ot1-f42.google.com. [209.85.210.42])
        by smtp.gmail.com with ESMTPSA id s20sm8203515oiw.53.2021.11.09.10.06.31
        for <stable@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 09 Nov 2021 10:06:32 -0800 (PST)
Received: by mail-ot1-f42.google.com with SMTP id h12-20020a056830034c00b0055c8458126fso13141632ote.0
        for <stable@vger.kernel.org>; Tue, 09 Nov 2021 10:06:31 -0800 (PST)
X-Received: by 2002:a9d:734a:: with SMTP id l10mr7706868otk.3.1636481191553;
 Tue, 09 Nov 2021 10:06:31 -0800 (PST)
MIME-Version: 1.0
References: <20211109010649.1191041-1-sashal@kernel.org> <20211109010649.1191041-10-sashal@kernel.org>
In-Reply-To: <20211109010649.1191041-10-sashal@kernel.org>
From:   Brian Norris <briannorris@chromium.org>
Date:   Tue, 9 Nov 2021 10:06:19 -0800
X-Gmail-Original-Message-ID: <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
Message-ID: <CA+ASDXPwH9esHZFVy4bD+D+NtfvU6qJ_sJH+JxMmj3APkdCWiw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 4.14 10/39] mwifiex: Run SET_BSS_MODE when
 changing from P2P to STATION vif-type
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        =?UTF-8?Q?Jonas_Dre=C3=9Fler?= <verdre@v0yd.nl>,
        Kalle Valo <kvalo@codeaurora.org>, amitkarwar@gmail.com,
        ganapathi017@gmail.com, sharvari.harisangam@nxp.com,
        huxinming820@gmail.com, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Mon, Nov 8, 2021 at 5:18 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Jonas Dre=C3=9Fler <verdre@v0yd.nl>
>
> [ Upstream commit c2e9666cdffd347460a2b17988db4cfaf2a68fb9 ]
...
> This does not fix any particular bug and just "looked right", so there's
> a small chance it might be a regression.

I won't insist on rejecting this one, but especially given this
sentence, this doesn't really pass the smell test for -stable
candidates. It's stuff like this that pushes me a bit toward the camp
of those who despise the ML-based selection methods here, even though
it occasionally (or even often) may produce some good.

Brian
