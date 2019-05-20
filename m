Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF9BA23577
	for <lists+stable@lfdr.de>; Mon, 20 May 2019 14:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391057AbfETMfW (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 May 2019 08:35:22 -0400
Received: from mail-it1-f170.google.com ([209.85.166.170]:40232 "EHLO
        mail-it1-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391068AbfETMfW (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 May 2019 08:35:22 -0400
Received: by mail-it1-f170.google.com with SMTP id h11so1170024itf.5
        for <stable@vger.kernel.org>; Mon, 20 May 2019 05:35:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:from:date:message-id:subject:to;
        bh=0wg7YYMkKqWvuguISa6ARNQuB0gtDasZcN2lWRgOgp4=;
        b=G324Aw1z3iUXZH1BA39jZL84+8gjCBOhm0smG3lsHV4KIcx/EX3KcKf77ddjm+Ef+U
         8SbMh8bEImoFMcDRWOvdzhcl6r7vXGmbBZB6/OpwSuPXlBfJBPeW5ZHwwVhtViiwHAvQ
         sadB3IqA8siB1LdyC2Vu28ngxW9d+Ov4Sd5igPjccxy5gQ9o/n02MIO9O5W/klPrBeuK
         XriDdJsgDozkKLaj11XfVv5Wq2YLx5HGBD3s5V+DbBmwOOF/Z2bYNRAgudzpSyCKNzau
         cuK+J6Tc2Q7TbH+u9elVNqNjAas1W4eXH2Vg/iT6wW7noQKkOXlFo4gvYshDz+CiaziX
         GbVQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=0wg7YYMkKqWvuguISa6ARNQuB0gtDasZcN2lWRgOgp4=;
        b=legiuLVZC3qriTryrzf286P2Kn69BgrH5Tp4lMIYJ4NPGY7nLYabfmBNDkAsaYZyFL
         KwME30UZyE/uITLcW1D1EKxtxrTCvJq3KPUIEcRLX3UOjoxODK7bB1J+IdAreCwHAgST
         LivuYirBGx6AmiZdetige11B3/2LCof6lVj+GEiJkNyspgyPLJ2cohhtGK9y5OtbItuI
         3EnyCpsJFFuFT6+8R5cboC4et40e9WqKhXx/iXY92DT4fbCmKeNOExgSAu1b3qPdukbD
         hslBFfdKYs/a9C7GYEgBfjMLoeLcSO3+7gzF9cM3wNAI1nXZ6G0j7fRACxhmzGrKsC6c
         41Aw==
X-Gm-Message-State: APjAAAWPGRZLCVNJzY9OZ8V3cgmtCcm8tqCAIqSFaoNUoRR+OSl/GYwp
        9iMzPd/9bC0F+F1GjKav7GHD9VVA2WtXXWDLSkZu04lk
X-Google-Smtp-Source: APXvYqwJ0hlgOpPw/VB9mlrP7u71y3KriuSniuhlSSauv3sg8BX4ViYqbgoIMlLREkk5BR3P2ocmGecXQLw/fDhqBcA=
X-Received: by 2002:a24:70ca:: with SMTP id f193mr12807302itc.103.1558355720822;
 Mon, 20 May 2019 05:35:20 -0700 (PDT)
MIME-Version: 1.0
From:   Adam Ford <aford173@gmail.com>
Date:   Mon, 20 May 2019 07:35:09 -0500
Message-ID: <CAHCN7xJPG_LE8JwA44WjmQi697XiMir6b5-d-du5wc-YAD-U5g@mail.gmail.com>
Subject: ARM: dts: imx6q-logicpd: Reduce inrush current on start
To:     stable@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

Please apply  dbb58e291cd4 ("ARM: dts: imx6q-logicpd: Reduce inrush
current on start") to the 5.1 stable branch.
