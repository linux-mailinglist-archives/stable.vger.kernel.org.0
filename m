Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3E21299C80
	for <lists+stable@lfdr.de>; Tue, 27 Oct 2020 00:59:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2411288AbgJZX7u (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 26 Oct 2020 19:59:50 -0400
Received: from mail-lj1-f193.google.com ([209.85.208.193]:40352 "EHLO
        mail-lj1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2411175AbgJZX7s (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 26 Oct 2020 19:59:48 -0400
Received: by mail-lj1-f193.google.com with SMTP id 23so12535093ljv.7;
        Mon, 26 Oct 2020 16:59:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=vA0yqlgv8BZU4FzIR60Mj5pzfuiNbfmhCbso2KenTsE=;
        b=I8WlpO2r7AFvoimcwGj4E2mHNAM7VhcQEEvGsXo39CzqzsIDb+bNZqNd01K8cBseNw
         +M9mkAJCcor5Vmo+fY4Io1ZsqYFFHFlxXAwPvkki3Fs+r4IXpWlKouVCfIvVHFFQOgRB
         Kq23xwdrwxa3Q3L3+YhZOCmdvMFk2RR6AhSSxE5OhaKMclXwGvAV02BNWSgcP949Y86O
         TJvGY13YOXt+QA5FxABhPXbrqPjKgyG3QqYMj1mddNxxg3YvD7Ay9YGu99mVMt3dtIDt
         qI0kLIz1BTPgr+QfmgPSthq+4bwS/CpX8VMIuqnt1WkZtSwNY0eiTIXbHP5tf+gloyDE
         Cm8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=vA0yqlgv8BZU4FzIR60Mj5pzfuiNbfmhCbso2KenTsE=;
        b=Z31oqS7JLB/JDGf98XTB0lDzwREECfXVQGca998tTWG4G8uGeoeVye8RVmRcB9sCGI
         Zkowvqk7lbsifirGiLhRt40SItwLQlM/jVJN+7sPBC2XxAvX/NiXSTiaR8ETIElMj2Jk
         lARL1TqgPUMgjPt85USXNGtj4a5Y0pba0OFhPxFjEecOEYeeIAkDfdrzSDhku8MYiO58
         geIv+CJ4XqIiwe/QKWKBWXwrVWf59Q2PGIXc1vyY5BXpdzE6EmaneqNLsBIA/2mkL43t
         y2Cg5uYL+RL8qWl4Oe34LZeTK/tJOR6w78g0lDt4qPoayHZCSignIQCumNicg7hJLhBO
         cagg==
X-Gm-Message-State: AOAM531RCIgMnzb0SMy51tECMfkNPf9xTFbQH9JMA1Iq1umIhh67601U
        X3Yr7MnCvR8qdR5Fq0rblxI1OKSHAME0ecTZ1pHTWE9P7SQ=
X-Google-Smtp-Source: ABdhPJyUmCq7ePK2IjaqPj9d6K+LEMjvSZw6c+p36G6enWe34rn9YpAgfDwSixwcqaynfYcxKca7kNf/8V2BTzIBN+g=
X-Received: by 2002:a2e:99ca:: with SMTP id l10mr6621825ljj.218.1603756785501;
 Mon, 26 Oct 2020 16:59:45 -0700 (PDT)
MIME-Version: 1.0
References: <20201026234905.1022767-1-sashal@kernel.org> <20201026234905.1022767-131-sashal@kernel.org>
In-Reply-To: <20201026234905.1022767-131-sashal@kernel.org>
From:   Fabio Estevam <festevam@gmail.com>
Date:   Mon, 26 Oct 2020 20:59:34 -0300
Message-ID: <CAOMZO5CF=KewxQm5jwXuwGDDeB1b_UqF4JZ5GqJpjV7LPR62zw@mail.gmail.com>
Subject: Re: [PATCH AUTOSEL 5.9 131/147] soc: imx: gpcv2: Use dev_err_probe()
 to simplify error handling
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>,
        =?UTF-8?Q?Guido_G=C3=BCnther?= <agx@sigxcpu.org>,
        Shawn Guo <shawnguo@kernel.org>,
        "moderated list:ARM/FREESCALE IMX / MXC ARM ARCHITECTURE" 
        <linux-arm-kernel@lists.infradead.org>,
        Anson Huang <Anson.Huang@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Hi Sasha,

On Mon, Oct 26, 2020 at 8:56 PM Sasha Levin <sashal@kernel.org> wrote:
>
> From: Anson Huang <Anson.Huang@nxp.com>
>
> [ Upstream commit b663b798d04fb73f1ad4d54c46582d2fde7a76d6 ]
>
> dev_err_probe() can reduce code size, uniform error handling and record t=
he
> defer probe reason etc., use it to simplify the code.
>
> Signed-off-by: Anson Huang <Anson.Huang@nxp.com>
> Reviewed-by: Guido G=C3=BCnther <agx@sigxcpu.org>
> Signed-off-by: Shawn Guo <shawnguo@kernel.org>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Does this qualify for stable since it is just a cleanup and not a bug fix?
