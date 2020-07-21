Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 797B8227437
	for <lists+stable@lfdr.de>; Tue, 21 Jul 2020 02:57:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726425AbgGUA5K (ORCPT <rfc822;lists+stable@lfdr.de>);
        Mon, 20 Jul 2020 20:57:10 -0400
Received: from sonic307-16.consmr.mail.ne1.yahoo.com ([66.163.190.39]:45332
        "EHLO sonic307-16.consmr.mail.ne1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726506AbgGUA5J (ORCPT
        <rfc822;stable@vger.kernel.org>); Mon, 20 Jul 2020 20:57:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1595293028; bh=0CHC+re3Lg12wtapqmZiuSmzuO0jp0HvYX3Xhxuru+I=; h=Subject:To:Cc:References:From:Date:In-Reply-To:From:Subject; b=gc50MvHwpsJUEN8yBYJ45+nt2gi0ECcAfnIrNDGl9elan6v+xnCWA7MzVC/ZWIUm9NzSodKMFQcd9acEFfazfcmzsIC7Lj1I5TG2LV1Q0hd9F9SW7Kx+SFKJNyW54RhyDz4fLTJpE6pO3hMU67wzIgvit2Bz86ubwxZBkxZvOmgtg6001IZNOdaDukMA8qgpvLpnTF13W6d6ufWrTcS/8xvc5SPgRiSS6ADAPJJ3cc4Ydhyrrb6wlh7nahh0Fvdvm9UVK6yyi6Ydw7R/cGleQPwPzK1FeWPimeOUL1+sovYmT556oyaOX4DTt3xgq3xJLYYJQntvhXsX7S2yOlK6Cg==
X-YMail-OSG: zLYKgBQVM1khUVbN7dTBmXEbI8LpzzshYS7aWJJehT22feStu5gXyOH.W8D.aD8
 mfoehi0R5XlNvoS0cqJmHAZkBFe1Ai_REvgHb6e68itl2qAlX7SLVomThNKber1cMByvZTa8nuXT
 DpKcnQt5ZDj1F1wTkxJW7fPOiX8bhP_Qm8CtI2vAGl_OThlf98pJWB_YN1LBOy41NP5ZgsPjI1r_
 pRPLu4q5RJTsTzQWkOYw0SN0FezwKSMpEZboI9DG.Zi5KlGzmganQ09uvwyYAAd8p2W2g0wQFqtw
 9b9E99Gi2iNiW7JwYb7gdMfmAubOF28RhZqUS3dr5nhU4dkaBNk805hMGsBoIQZL7hZnUPAyMbxB
 GKk5ZCFwVa0HzIi1mQGe8xE1vi4b3av9X0E8Qli97k8dky8KfabxaYh0XdLzxdB.4_.gWrbbaFS4
 M2jv5Ds_6bab1LYun_ZreWZW0mtY4A02mcpFLgO_rcbLKe6nIdklZG.Cx4uRTc4cEIKrPGeNNgp2
 M2bpU1F3bIYTcU8WWej4EB5mW3XP333H_XaPWnU1LL39DusL3a7zHzwiJA6ffqAqBJUigxsWwljv
 SETtZIQcgudD1kU21oOPRvyjRiEgK0vkGQuh_ai2yfQ7AKAIP._C42W_hEm7UkASTPAZo5UDnu6i
 SSuWY9ZF_1KUkNPkNZZss69S.KXBF9mCzD3jCkEsAjGRX.9JSoRahGxJHOaimSKSzGBA6zvU0OlQ
 enXybu4HKqsA4r3L0f1WZT4eAqGFPuRI._1w7k_YsnBinuYXKvKMkTm3moCAYlLqGNI1I6GGUzLG
 yx8hCu8Bdd6j9StIODgBKVvcRs8mSTep0xPaTrD9Y6tGP4MA5HM9m_Z0QuTgJiz9.H3.ll78OhEB
 .mPYAQmjd2cyCtNAA9.WJrnHlpjgffXZszPE8QqVfK7Dn7KWZXzKeW6qzP7kQt5BMUZbQlXcmGS4
 o8e2nbjU7eHYlGHyRa581gx16nx1iIHScpRlLI1eNUc_BzFPAEhvAInkExqWeZ45P8dKnxiw21Gi
 1J0qD_UI870pQx89JiMUFJNWZg0guyNh2vmNswCEtvV8sxwDO_SF3jmAJJoEv8epvrlt7lwrwsdV
 4zmwFQ9buw8nLhYcy9uL3Vkmc5FO2pZiGpBVsAGluf0t1vOY4skZjzVTCyN0igKx0D88iISOfafC
 DljfnWNPpnU_7fiPwhgdhlyeP6A7hX1jmopNpuaMxxyVaFJEUc7kSAPKIcR_ZGbVYAPU1Avbrw2k
 gVfzyefxu7nlWbbrxIhxwtip.dzop4cqu6p9RXJCXjtED7sa0pn55fv2HC8s7e6zHuCG6l1qatO2
 Ife0ZfVS8.QHHuKgbX.6CLs4_DwNcK93DXVrJNmjxhEZApBGDG4LrLld5tlqhEUlo.Mw891AvQFH
 QhqzvEUvtSqFyxYAI6Hj.xyc-
Received: from sonic.gate.mail.ne1.yahoo.com by sonic307.consmr.mail.ne1.yahoo.com with HTTP; Tue, 21 Jul 2020 00:57:08 +0000
Received: by smtp421.mail.ne1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID 7f1506f069518a44952a27ea8fef8594;
          Tue, 21 Jul 2020 00:57:04 +0000 (UTC)
Subject: Re: [PATCH] Smack: fix use-after-free in smk_write_relabel_self()
To:     Eric Biggers <ebiggers@kernel.org>,
        linux-security-module@vger.kernel.org,
        James Morris <jmorris@namei.org>,
        "Serge E . Hallyn" <serge@hallyn.com>
Cc:     syzkaller-bugs@googlegroups.com, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org,
        syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <0000000000000279c705a799ae31@google.com>
 <20200708201520.140376-1-ebiggers@kernel.org>
 <20200721003830.GC7464@sol.localdomain>
From:   Casey Schaufler <casey@schaufler-ca.com>
Message-ID: <4b7b9cbc-2c8d-0582-67f4-a8b095b78959@schaufler-ca.com>
Date:   Mon, 20 Jul 2020 17:57:03 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200721003830.GC7464@sol.localdomain>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Mailer: WebService/1.1.16271 hermes_yahoo Apache-HttpAsyncClient/4.1.4 (Java/11.0.7)
Sender: stable-owner@vger.kernel.org
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

On 7/20/2020 5:38 PM, Eric Biggers wrote:
> On Wed, Jul 08, 2020 at 01:15:20PM -0700, Eric Biggers wrote:
>> From: Eric Biggers <ebiggers@google.com>
>>
>> smk_write_relabel_self() frees memory from the task's credentials with
>> no locking, which can easily cause a use-after-free because multiple
>> tasks can share the same credentials structure.
>>
>> Fix this by using prepare_creds() and commit_creds() to correctly modify
>> the task's credentials.
>>
>> Reproducer for "BUG: KASAN: use-after-free in smk_write_relabel_self":
>>
>> 	#include <fcntl.h>
>> 	#include <pthread.h>
>> 	#include <unistd.h>
>>
>> 	static void *thrproc(void *arg)
>> 	{
>> 		int fd = open("/sys/fs/smackfs/relabel-self", O_WRONLY);
>> 		for (;;) write(fd, "foo", 3);
>> 	}
>>
>> 	int main()
>> 	{
>> 		pthread_t t;
>> 		pthread_create(&t, NULL, thrproc, NULL);
>> 		thrproc(NULL);
>> 	}
>>
>> Reported-by: syzbot+e6416dabb497a650da40@syzkaller.appspotmail.com
>> Fixes: 38416e53936e ("Smack: limited capability for changing process label")
>> Cc: <stable@vger.kernel.org> # v4.4+
>> Signed-off-by: Eric Biggers <ebiggers@google.com>
> Ping.

I have queued your patch and will be pushing it for next shortly.

