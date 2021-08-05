Return-Path: <stable-owner@vger.kernel.org>
X-Original-To: lists+stable@lfdr.de
Delivered-To: lists+stable@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 932793E171C
	for <lists+stable@lfdr.de>; Thu,  5 Aug 2021 16:40:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241648AbhHEOlK (ORCPT <rfc822;lists+stable@lfdr.de>);
        Thu, 5 Aug 2021 10:41:10 -0400
Received: from sonic308-54.consmr.mail.gq1.yahoo.com ([98.137.68.30]:40795
        "EHLO sonic308-54.consmr.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S241189AbhHEOlK (ORCPT
        <rfc822;stable@vger.kernel.org>); Thu, 5 Aug 2021 10:41:10 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.ca; s=s2048; t=1628174456; bh=fwbHdeP437tCU2ko/QDbESZB4htsuRB5ELv1H5ubPIw=; h=From:To:Cc:Subject:Date:References:From:Subject:Reply-To; b=MczBU/Z8So2eqaucEKzK5anokdNbe9wIcWt9a0eeuh3ttOXu03nErUmodRkqxiJWem+ExZE+bgw7jZKRNJk7cM6Sb4qPQQjGp9hzT45JkVFuWPt3GX+qAukXQF45THysf5TZlOQA8bfGQeRXM8LBugPEVwGkPWuUwo0EzuCnXdO6gZ97XqQYhkKUY6ZhiFELT1EGULfb6LJXsXavqWxZvqh63KxNcZPvqDkw5xYRPiXMscMk3vB5nmfuVJBnkLSQ4Cj/PlOkswUeJ94gkRZPd3RjrzT3sLiRqSLHDxAsq/gWNYaXxtA1opTsgUAbS+DbFlqo+vHk3fmrlCIx4qltmw==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1628174456; bh=QcwPXF8n/HpDDX2OYLZtPvh9Wkd//xi1jURcudsqMhW=; h=X-Sonic-MF:From:To:Subject:Date:From:Subject; b=f++jXK/jsk4tbBdVuD0nHY7b59uYsbhACy7/Su78Ze5z/4E+3SS+qniMJkPVEs62NmjV/PsR+xvdPWxUtUu4cqLG0TFJn16+hK5ByNeGzYN70MsAAS0B5hPR3GyrOsIZcM1FZm8YWiDQoZzR9rKAgN6SPGyCfhQ9zGqup+TqdBKF278+H81WEKnKqX3RQ/njKdc70Ja3KRvvGG6hQhVgnfy1S9zduO5YD1GBXR/+NxKyz16aVDhPObwAopPXDQpWAB2r0wbIdz7zhEe9rJuLa+xbcaFAvGLemkv0d//jaV1yRcoMXL+Yf76zICAxImDJtjdAIojIwAhv/759lmeN2w==
X-YMail-OSG: KxWa1usVM1leM52TRzjXo_iHBnXDpJOX2_DFAKlvoyDlvq5MnAzojd7_2NeSF6A
 5ienRCkP0t7H89J8PJmGkwt3c3GlDq4J3hyzsreVmvy0Jsgyf6wuBzF6FyavkschcnddzXGBA0Rs
 PZ54J0ILjPmGrTFWvFyX9RI8xjrVbaSGinKoMRrLC52rJOVBPcYt6tBpt2IZF1REX5x55d1jlcHG
 6de.HtHK2502hYD3joAkt4fVPjCrlnBUPlrcC34y5Yoy__YKakf54Yt9qF4SDyd5G79k8bgAvadW
 h2V.7OPnper5cQcwzcQ__srKpwbdPrsDCsH2OGO.SdWTUeqy27EPBjhmEHPozGyABBk4g4iMFDvE
 jFljFVq9D4locQfkJEBa4yLvTRRX3ibvViOxOEQ9bcfEhqkxhPb6V_AZdm6ViamrJpDIv0JNtPhy
 JeW6CoXBBxHjvA41jZcY1XZyTDpOhDNX9O4OQeB4mytIeKuxwfLu6fWZokm_zxbnxu1A6OeBmYg2
 NR2ewCCWSexy2hH9IDa9SLOZaxQnGG.GpJ221IcO0t_51AYLUe3m_KTr4f43hwDXqw6rwoL5Yurl
 XOR7KK7m6StoDxf7lnM03fSLHUOszMi.bpjh8swRbNlhkTG83w4UL3VWcCG6BjVfHrMmhtiCQnTA
 QYnIzbddPWqWDZFWNTLbyMzKSA.dqajxpP1UJJUX2I_Kny_9GXzj.VX.wUIp.qXlUhzdw5ykU8Lb
 gD2SDlxkJlJ.Y6fhDkS2U7JWNsqhzJl1d4ubI2.QlPt9D6TyGbQ2ZV9hWPNO9BhUbOVWRubh7MYL
 cd0yNUdIyc6rZP9hEhQ.s.lc6_xYW69k1X.s0_pseVHmJydRv24WdbA0fHxy8wJAhKbEdjd7eFVk
 n7MF9.UbA81WpijMAvOrqFGMifvSIkfmFeMXfvlmFMVzuyZUa0a98L3beO9.9ycK.toJGdaQIHOi
 ZU8YK25Vc7QqC.yGyqF6U5WTaqLEyrdZP_CDD1w405llmMIXaUCZ3N_dmgCMhURliqv8JGULmEmw
 eKaoP4L3PCwkZEP5YBrU4U3pmQyhmJdB2JH8c2nZH9I4vKyT1XRMCBjM7mL8zJJ1wxys8ze6QXkz
 ZC5HOCsmtEKR5QD5SmJJCsq9znBXVEg5xyZwyG_1qV2tSK2TMCWrMFexLy4Ezv72V0YVzVckqkoy
 TyldiYpZTs6d3JiNIeZq9lymcNrh_.3QQFUiyeUbKpw8XVSZMVcPh0o_Ryb5qCwcU9T5lSR6mtyN
 PpwIp1mbampDls3WeE2HEAGqrsXQ3lGrxKkHsqAUwN.97VIAg_tWs4tCIC4HTKLtUrfQpxYiFaVe
 Rlip4YO.5ck7GiFhvifAYkZXDpYCxnCKUlcrzqZGFtKCnFhAIbjGHBVgbIrE9da4PooXWa7GAQXB
 4mW1LM8Rv3133Yfo6tHei9Hgy2RW2VRAQjSISuHYdiRT.QG2XvPncaNK9a9SlzivGUuj8h2Ut1xv
 _tYf0dC3CvmJMJnmNRFXa1NygHlC6yn2Cki4jw2IKlFAH086i_bh7vwc0CyscUpg31iOCa1Qcw5E
 vUNN7ypwf_wSawzPjk.yXO9lOPGjowYyOL1dVQpyesV4agDMuwcedpE_.LMwKcR8FykZZ176ZYmo
 YSwdFLcz1oaZ_84i0yiEvQT04F9cArfClt.laQgbj21SOc3Iet5GsKvDmAciPL9LC61pZ2t3QQlg
 uUXhmmRkJYZs2PciBJsMyAWVWK38FmEpyThPCeqe.WuQQw9Yqpl63KheJOJyxvoxnXhZsWRCFv46
 VSNofvYXwB6PXkMhjUCB.0fFvV8SmEzTdG_CmAI9pPMaDYrxeyjOLQpbRBRQpGEEYYjmDzzxRhwl
 CJqqkMi65Y4W_dD8x84ePrSMfTr3K1hFFMTlUVW7iq_Be2Rvg1H0H5mXdrkg2E3kv4DP.UB.86K7
 7y9ZwxTGX3m27qHsphfr.vwiTK8un2mfFx6iICnh9Chz54zYxxCkSzb1UuTlxzHLxg10H9Lf0pRp
 BLdw.kXdlGMRzMSy4rOhXbNhcY.QUbj1dFR7mtW4OVIh1IshUXFZ_SGEGvEXeHQNW8geKv_xKozQ
 dl3mNGYZd86bru.J8Qa0.CpdPoHJIvUCMjVxqHtmo6bscqT3Oi3hENdKNdCVZVxmTWYx4m6GMAl_
 tEqvFGYnPDM02TD99Gkv.6xnwyJszeb9E7You37JgOt4AcVTW6bkqeWUVqaQdSGTw90lihq3t2Qq
 wPoQl.K2B5.iNNiy0au9kOY2enXOool8YhXnNDDlJRD.wVjnSH0xSHlIFwiOE2WgfXLOLSxYdmWz
 xefo_cyoYUmfGPz0ZeifofXD3aB84fYyJTpz61NRHwVaaiRE4V6Z7VyicwhqzHxYVeNhuGpTcYTw
 pSkdZEWInTBOQxp7sPAu3FuS9SfebbblEhnP1cIP0LdXxgGLBgP2XGzFJ10qNR3UE3PhIhoVBamh
 NBuOUmA.tlSrJKx_9SrvMuLfLAOmGhANwpKM7XFst.gqFulBPGu9y9_RfWSPylYVSasjfd9yOtG0
 B.aoFPhP0JRij68ocmXqwU2hEWCNXWqa4LzgaTgjXA7BtKQs0.YfiYhj_S3FYy9sBftLfrEYIkHT
 aUcwe9l9qC12Z0SMLuLHBxJCvefszuEyQ6efBxY8Zs55eiOAxcELoicG2UDUPWyGVj3J92E37S17
 vRr4w6Mu.gkAVL8wrpTOpU8a_v4sWl3fIQmNQUbkabYVhXvwFEq5x6NbWK9nRPmf9F.wOLkG4Ljy
 7HjtvbLP7vn08FmbmoFgJvHDdt7sq3ulsVN3th_dTSwv7zyVCDdir40S.RxXmVRUtgIjHlXqPeMV
 6EavnnJNWKxivn0JLnLEMz_6H.rn.ApFHnt8Wtt_OQej24O_VYedcTgcrjOtCaOuA4pxcbRkPQEV
 RTDnzR_w03t6wa4KIAadGIi8lDSgqWaBUxmyaIzIHe3KdYIbx.eGfmC_Kwa.dhHlovKFjYH936t_
 BBlpm95GwumF5_wEdg304GBIlX.Xpr9RL9r42CRantxmVt0ZfUa55OFVGS35s_TWeLLQ5H04.G7G
 JroZIsejvv1oBM6ctlYiOhtITyuY.yiHZ7OGYzGd8vhPf7.Bmqn4vus6XLnA2pe8KSU6hiduN.aF
 2t_bIhi3VnLG6MpHoT52QT4CP0nrH1jH0zTWS7cIYtMrUE1LF17pjCo0mdgBAKuAoRYABddcAViW
 fUwfOq4zeJEz2ryOpj1vRd611D1bm7bTUZ6me_tPaCp1FNmkF4J7OkHwzYtuNBSYyQzYh5d.ULiM
 LcKStHFi8Ttk9jn7Q96qT4sOSfjQCks2sxARwOQCiX4.UxlC0oBS9S.8h0KrbwWz7H.Li75jCH2n
 S5CWJ1AzCiHdMlRueCBkoQoTqY7o8Xqph
X-Sonic-MF: <alex_y_xu@yahoo.ca>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.gq1.yahoo.com with HTTP; Thu, 5 Aug 2021 14:40:56 +0000
Received: by kubenode503.mail-prod1.omega.gq1.yahoo.com (VZM Hermes SMTP Server) with ESMTPA ID ce6bf6fcf5da7d3f48ed15ca8e5ee197;
          Thu, 05 Aug 2021 14:40:50 +0000 (UTC)
From:   "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>
To:     torvalds@linux-foundation.org
Cc:     linux-fsdevel@vger.kernel.org, linux-api@vger.kernel.org,
        linux-kernel@vger.kernel.org, dhowells@redhat.com,
        linux@rasmusvillemoes.dk, gregkh@linuxfoundation.org,
        peterz@infradead.org, nicolas.dichtel@6wind.com, raven@themaw.net,
        christian@brauner.io, "Alex Xu (Hello71)" <alex_y_xu@yahoo.ca>,
        stable@vger.kernel.org
Subject: [PATCH] pipe: increase minimum default pipe size to 2 pages
Date:   Thu,  5 Aug 2021 10:40:47 -0400
Message-Id: <20210805144047.13518-1-alex_y_xu@yahoo.ca>
X-Mailer: git-send-email 2.32.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
References: <20210805144047.13518-1-alex_y_xu.ref@yahoo.ca>
Precedence: bulk
List-ID: <stable.vger.kernel.org>
X-Mailing-List: stable@vger.kernel.org

This program always prints 4096 and hangs before the patch, and always
prints 8192 and exits successfully after:

int main() {
    int pipefd[2];
    for (int i = 0; i < 1025; i++)
        if (pipe(pipefd) == -1)
            return 1;
    size_t bufsz = fcntl(pipefd[1], F_GETPIPE_SZ);
    printf("%zd\n", bufsz);
    char *buf = calloc(bufsz, 1);
    write(pipefd[1], buf, bufsz);
    read(pipefd[0], buf, bufsz-1);
    write(pipefd[1], buf, 1);
}

Note that you may need to increase your RLIMIT_NOFILE before running the
program.

Fixes: 759c01142a ("pipe: limit the per-user amount of pages allocated in pipes")
Cc: <stable@vger.kernel.org>

Link: https://lore.kernel.org/lkml/1628086770.5rn8p04n6j.none@localhost/
Link: https://lore.kernel.org/lkml/1628127094.lxxn016tj7.none@localhost/

Signed-off-by: Alex Xu (Hello71) <alex_y_xu@yahoo.ca>
---
 fs/pipe.c | 19 +++++++++++++++++--
 1 file changed, 17 insertions(+), 2 deletions(-)

diff --git a/fs/pipe.c b/fs/pipe.c
index 9ef4231cce61..8e6ef62aeb1c 100644
--- a/fs/pipe.c
+++ b/fs/pipe.c
@@ -31,6 +31,21 @@
 
 #include "internal.h"
 
+/*
+ * New pipe buffers will be restricted to this size while the user is exceeding
+ * their pipe buffer quota. The general pipe use case needs at least two
+ * buffers: one for data yet to be read, and one for new data. If this is less
+ * than two, then a write to a non-empty pipe may block even if the pipe is not
+ * full. This can occur with GNU make jobserver or similar uses of pipes as
+ * semaphores: multiple processes may be waiting to write tokens back to the
+ * pipe before reading tokens: https://lore.kernel.org/lkml/1628086770.5rn8p04n6j.none@localhost/.
+ *
+ * Users can reduce their pipe buffers with F_SETPIPE_SZ below this at their
+ * own risk, namely: pipe writes to non-full pipes may block until the pipe is
+ * emptied.
+ */
+#define PIPE_MIN_DEF_BUFFERS 2
+
 /*
  * The max size that a non-root user is allowed to grow the pipe. Can
  * be set by root in /proc/sys/fs/pipe-max-size
@@ -781,8 +796,8 @@ struct pipe_inode_info *alloc_pipe_info(void)
 	user_bufs = account_pipe_buffers(user, 0, pipe_bufs);
 
 	if (too_many_pipe_buffers_soft(user_bufs) && pipe_is_unprivileged_user()) {
-		user_bufs = account_pipe_buffers(user, pipe_bufs, 1);
-		pipe_bufs = 1;
+		user_bufs = account_pipe_buffers(user, pipe_bufs, PIPE_MIN_DEF_BUFFERS);
+		pipe_bufs = PIPE_MIN_DEF_BUFFERS;
 	}
 
 	if (too_many_pipe_buffers_hard(user_bufs) && pipe_is_unprivileged_user())
-- 
2.32.0

