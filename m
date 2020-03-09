Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8B76617DC67
	for <lists+stable@lfdr.de>; Mon,  9 Mar 2020 10:29:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725962AbgCIJ3J (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 9 Mar 2020 05:29:09 -0400
Received: from mail-lf1-f68.google.com ([209.85.167.68]:39723 "EHLO
        mail-lf1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725956AbgCIJ3I (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 9 Mar 2020 05:29:08 -0400
Received: by mail-lf1-f68.google.com with SMTP id j15so7070010lfk.6
        for <stable@vger.kernel.org>; Mon, 09 Mar 2020 02:29:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/x3bOS8+EQ730wvwzViwYAyxSIAy+Gqe4DlDcCBFmac=;
        b=e7eCoXwJn2Jq3avlPXDgQK9Rx/D9sv6dMMc8asjsu4JqGIdjFQ3+Tvma1SXSOhr7YI
         gQznjl6GdDgBkjgwCtHbuqrUoNwW+q1mYBZlXjqVLNH9OtaWlHwrTydkv/lBF9uMCHLo
         /2D0ERQdHCCCHUQ8MgMPH6ocbKoE0iD+vAgs4Feiu2PU4KEU/Lk8dU3I0jDfk4fnsdP7
         Cc88vNqxKVhDyZP8ACw+iid8ZvAxTgEioqBRlvDYEi633fqtmjmvJxUgjkvwm4+Maftd
         otTV8ue5JmmtIS4Es8BgpsbROdUrHq0Fe7jt2BevM2NF16Ty6aktOTSgqE+GGnH73Dt2
         Z3Mg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/x3bOS8+EQ730wvwzViwYAyxSIAy+Gqe4DlDcCBFmac=;
        b=QSTki3Z/KlBYq0b5Stjxz6V5hTvPI7pW0R2G2ejF8r+bHyRK8KX7kBg8h7GwuQTGdW
         lmEeWglEYODhTB3Nv5lGA0CI+W2n9Z2z1u/o0zV7DPUTrgaYMP69FIB9cnhEaf+pF0CH
         uJpTNNERO1p3UFwD8K7R8YdywMJouAcfIdzpe/KddqKp53qjmFNOx1WVSPMK99+hautU
         xGtaxlro6wPkLBVrE1O4O8QwHUkkD+AZRxKO+z/eFmZvfbdb9i1uaR+IF6YyVzLay5Bq
         nmO9Q5yQG4D+MZu25uzjr8idWQFAi+2I9A9kLGlcrVULF4TPRfTwanx490JeCkxK3vCK
         xSyg==
X-Gm-Message-State: ANhLgQ2mgX4Ix4SNA/2zSY047QQ5HTQBOG9usqK9wZ6vBBEymKp4pAi3
        p2h2vs0TzS9nVZbAFzO8AW/QmzI6QfBti5Yu/Z96vQ==
X-Google-Smtp-Source: ADFU+vsM0JTR3ANUQQsabsuZJsGRykwEGIjqSJXt/IVH98XX9FTs6BBkjNP3H6lsmBa6je9qc6mHr1lZrLe8Agh2tcQ=
X-Received: by 2002:a19:f503:: with SMTP id j3mr8990215lfb.77.1583746146910;
 Mon, 09 Mar 2020 02:29:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200305182245.9636-1-dev@kresin.me>
In-Reply-To: <20200305182245.9636-1-dev@kresin.me>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Mon, 9 Mar 2020 10:28:55 +0100
Message-ID: <CACRpkdbBao6ij4SNDJso2X0q0gbU38PQu0DUtWk+QyV7KW4njA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl: falcon: fix syntax error
To:     Mathias Kresin <dev@kresin.me>
Cc:     "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On Thu, Mar 5, 2020 at 7:22 PM Mathias Kresin <dev@kresin.me> wrote:

> Add the missing semicolon after of_node_put to get the file compiled.
>
> Fixes: f17d2f54d36d ("pinctrl: falcon: Add of_node_put() before return")
> Cc: stable@vger.kernel.org # v5.4+
> Signed-off-by: Mathias Kresin <dev@kresin.me>

Patch applied for fixes with Thomas Ack.

Yours,
Linus Walleij
